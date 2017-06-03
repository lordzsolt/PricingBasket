//
//  ProductCellViewModel.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/4/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

class ProductCellViewModel {
    let name: String
    let priceText: String

    var countText: String {
        return String(count)
    }

    var count = 0

    init(product: Product) {
        name = product.name
        priceText = "\(product.priceInUSD) \(Strings.General.defaultCurrencyAbbreviation)"
    }
}
