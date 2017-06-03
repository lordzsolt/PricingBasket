//
//  Cart.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

struct Cart {
    private var products: [Product: Int] = [:]

    mutating func add(_ product: Product) {
        add(product, number: 1)
    }

    mutating func add(_ product: Product, number: Int) {
        if let currentCount = products[product] {
            products[product] = currentCount + number;
        }
        else {
            products[product] = number;
        }
    }

    mutating func remove(_ product: Product) {
        remove(product, number: 1)
    }

    mutating func remove(_ product: Product, number: Int) {
        guard let currentCount = products[product] else {
            // Maybe throw an exception
            return
        }

        if currentCount > number {
            products[product] = currentCount - number
        }
        else {
            products.removeValue(forKey: product)
        }
    }

    mutating func removeAll(_ product: Product) {
        products.removeValue(forKey: product)
    }

    mutating func empty() {
        products.removeAll()
    }

    func content() -> [Product: Int] {
        return products
    }

    func numberOf(_ product: Product) -> Int {
        return products[product] ?? 0
    }
}
