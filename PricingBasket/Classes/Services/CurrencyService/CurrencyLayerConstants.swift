//
//  CurrencyLayerConstants.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

enum CurrencyLayer {
    enum URL {
        private static var baseUrl = "http://apilayer.net/api/"
        static var list = CurrencyLayer.URL.baseUrl + "list?"
        static var live = CurrencyLayer.URL.baseUrl + "live?"
    }

    enum Keys {
        static var accessKey = "access_key"
        static var source = "source"

        static var success = "success"
        static var currencies = "currencies"
        static var quotes = "quotes"
        static var timestamp = "timestamp"
    }

    enum Error {
        static var general = "An unexpected error occured. Please try again later."
        static var timeout = "Your request timed out. Please make sure you have a stable internet connection, then try again."
        static var service = "An error occured while loading currency information. If this problem persists, please contacts us."
    }
}
