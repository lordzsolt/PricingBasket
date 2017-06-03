//
//  DetailViewModel.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/4/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

class DetailViewModel {
    public weak var viewDelegate: DetailViewModelViewDelegate?

    public private(set) var currencies: [Currency]?

    public private(set) var selectedCurrency: Currency {
        didSet {
            DispatchQueue.main.async {
                self.viewDelegate?.viewModelDidUpdateSelectedCurrency(self)
            }
        }
    }

    public private(set) var initiallySelectedCurrencyIndex: Int = 0
    
    public var priceString: String {
        return String(format:"%.2f", pricingService.cost(of: cart, in: selectedCurrency))
    }

    public var currencyAbbreviation: String {
        return selectedCurrency.abbreviation
    }

    public var loadingStateCallback: ( (Bool) -> Void )? {
        didSet {
            DispatchQueue.main.async {
                self.loadingStateCallback?(self.isLoading)
            }
        }
    }

    private var isLoading: Bool {
        didSet {
            DispatchQueue.main.async {
                self.loadingStateCallback?(self.isLoading)
            }
        }
    }

    private let cart: Cart
    private let pricingService: PricingService
    private let currencyService: CurrencyService

    init(cart: Cart, pricingService: PricingService, currencyService: CurrencyService) {
        self.cart = cart
        self.pricingService = pricingService
        self.currencyService = currencyService

        self.selectedCurrency = Currency(abbreviation: Strings.General.defaultCurrencyAbbreviation, name: Strings.General.defaultCurrencyName, conversionRate: 1.0)

        isLoading = true
        currencyService.getCurrencies { [weak self] response in
            switch response {
            case .success(let currencies):
                self?.currencies = currencies
                if let selectedIndex = currencies.index(where: { $0.abbreviation == self?.selectedCurrency.abbreviation }) {
                    self?.initiallySelectedCurrencyIndex = selectedIndex
                }
            case .failure(let message):
                DispatchQueue.main.async {
                    self?.viewDelegate?.errorOccurect(in: self!, message: message)
                }
            }

            self?.isLoading = false
        }
    }

    func selectCurrency(at index: Int) {
        if let selectedCurrency = currencies?[index] {
            self.selectedCurrency = selectedCurrency
        }
    }
}

protocol DetailViewModelViewDelegate: class {
    func viewModelDidUpdateSelectedCurrency(_ viewModel: DetailViewModel)
    func errorOccurect(in viewModel: DetailViewModel, message: String)
}
