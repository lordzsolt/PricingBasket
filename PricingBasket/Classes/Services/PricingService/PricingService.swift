//
//  PricingService.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/4/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

struct PricingService {
    func cost(of cart: Cart) -> Float {
        return cart.content().reduce(0) { previous, entry -> Float in
            return previous + entry.key.priceInUSD * Float(entry.value)
        }
    }

    func cost(of cart: Cart, in currency: Currency) -> Float {
        return cost(of: cart) * currency.conversionRate
    }

    func price(of product: Product, in currency: Currency) -> Float {
        return product.priceInUSD * currency.conversionRate
    }
}
