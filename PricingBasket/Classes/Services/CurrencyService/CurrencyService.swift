//
//  CurrencyService.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/4/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Service for loading the available currencies and their exchange rates
class CurrencyService {
    private let layerService: CurrencyLayerService
    private let source: String
    private var currencies: [Currency]?
    private var exchangeRatesTimestamp: TimeInterval = 0
    private var loadInProgress: Bool = false
    private var completion: ( (Response<[Currency]>) -> Void )?

    init(apiKey: String, sourceCurrencyAbbreviation: String) {
        source = sourceCurrencyAbbreviation
        layerService = CurrencyLayerService(apiKey: apiKey, source: sourceCurrencyAbbreviation)

        // Preload data on a background thread
        loadCurrencies(nil)
    }

    func getCurrencies(_ completion: @escaping (Response<[Currency]>) -> Void) {
        if !shouldIgnoreLocalCache(), let currencies = currencies {
            // Preload already finished
            completion(.success(currencies))
            return
        }

        if self.loadInProgress {
            // Preload is still in progress, save the completion block to call once preload finishes
            self.completion = completion
            return
        }

        loadCurrencies(completion)
    }

    private func loadCurrencies(_ completion: ( (Response<[Currency]>) -> Void )? ) {
        loadInProgress = true

        loadCurrencyInfoFromAPI { response in
            var currencyResponse: Response<[Currency]>!

            defer {
                self.loadInProgress = false
                completion?(currencyResponse)
                self.completion?(currencyResponse)
            }

            switch response {
            case .failure(let error): currencyResponse = .failure(error)
            case .success(let (availableJson, exchangeRatesJson)):

                guard let availableCurrencies = availableJson[CurrencyLayer.Keys.currencies].dictionary, let exchangeRates = exchangeRatesJson[CurrencyLayer.Keys.quotes].dictionary else {
                    currencyResponse = .failure(CurrencyLayer.Error.general)
                    return
                }

                self.exchangeRatesTimestamp = exchangeRatesJson[CurrencyLayer.Keys.timestamp].double ?? NSDate().timeIntervalSince1970

                let currencies:[Currency] = availableCurrencies.flatMap { (abbreviation, details) in
                    let key = self.source + abbreviation
                    guard let name = details.string, let exchangeRate = exchangeRates[key]?.float else {
                        return nil
                    }
                    return Currency(abbreviation: abbreviation, name: name, conversionRate: exchangeRate)
                    }.flatMap { $0 } // Filter out nils
                    .sorted(by: {
                        return $0.0.abbreviation < $0.1.abbreviation
                    })

                self.currencies = currencies
                currencyResponse = .success(currencies)
            }
        }
    }


    /// Perform two simultaneous API requests to get a list of available currencies and the exchange rates.
    ///
    /// If either request fails, the whole request will be considered a failure
    ///
    /// - Parameter completion: The completion block to be called once both requests finish
    private func loadCurrencyInfoFromAPI(_ completion: @escaping (Response<(JSON, JSON)>) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            let requestGroup = DispatchGroup()

            requestGroup.enter()
            var firstResponse: Response<JSON>? = nil
            self.layerService.loadAvailableCurrencies { response in
                firstResponse = response
                requestGroup.leave()
            }

            requestGroup.enter()
            var secondResponse: Response<JSON>? = nil
            self.layerService.loadExchangeRates { response in
                secondResponse = response
                requestGroup.leave()
            }

            // Wait for both requests to finish or timeout after 15 seconds
            let finished = requestGroup.wait(timeout: .now() + 15)

            guard finished == .success else {
                completion(.failure(CurrencyLayer.Error.timeout))
                return
            }

            let responses = (firstResponse!, secondResponse!)

            switch responses {
            case (.success(let firstJson), .success(let secondJson)): completion(.success( (firstJson, secondJson) ))
            case (.failure(let error), .success(_)): completion(.failure(error))
            case (.success(_), .failure(let error)): completion(.failure(error))
            case (.failure(let error), .failure(_)): completion(.failure(error))
            }
        }
    }

    private func shouldIgnoreLocalCache() -> Bool {
        let currentTimestamp = NSDate().timeIntervalSince1970
        return currentTimestamp - exchangeRatesTimestamp > 60 * 60 // More than one hour passed since last request
    }
}
