//
//  Strings.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/4/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

enum Strings {
    enum General {
        static var ok = "Ok"
        static var defaultCurrencyAbbreviation = "USD"
        static var defaultCurrencyName = "United States Dollar"
        static var noInternetConnection = "Sorry, but an internet connection is required for the application to work correctly"
    }

    enum MainScene {
        static var screenTitle = "Products"
        static var checkoutButton = "Checkout"
    }

    enum DetailScene {
        static var screenTitle = "Checkout"
        static var totalLabel = "Total:"
        static var done = "Done"
    }

    enum ErrorMessage {
        static var cartIsEmpty = "You must buy something before checkout"
    }
}
