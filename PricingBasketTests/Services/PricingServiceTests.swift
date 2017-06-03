//
//  PricingServiceTests.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/4/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import XCTest
@testable import PricingBasket

class PricingServiceTests: XCTestCase {
    var pricingService: PricingService!

    override func setUp() {
        pricingService = PricingService()
    }

    override func tearDown() {
        pricingService = nil
    }

    func testEmptyCartIsFree() {
        let cart = Cart()
        XCTAssertTrue(pricingService.cost(of: cart) == 0)
    }

    func testEmptyCartIsFreeWithDifferentCurrency() {
        let cart = Cart()
        let currency = Currency(abbreviation: "EUR", name: "Euro", conversionRate: 2.0)

        XCTAssertTrue(pricingService.cost(of: cart, in: currency) == 0)
    }

    func testCartIsCorrectlyPriced() {
        var cart = Cart()
        let product = Product(name: "Peas", priceInUSD: 1.55)

        cart.add(product)
        cart.add(product)

        XCTAssertTrue(pricingService.cost(of: cart) == 2 * 1.55)
    }

    func testCartIsCorrectlyPricedInOtherCurrency() {
        var cart = Cart()
        let product = Product(name: "Peas", priceInUSD: 1.55)

        cart.add(product)
        cart.add(product)

        let currency = Currency(abbreviation: "EUR", name: "Euro", conversionRate: 2.0)

        XCTAssertTrue(pricingService.cost(of: cart, in: currency) == 2 * 1.55 * 2.0)
    }

    func testCanConvertIndividualProductPrice() {
        let product = Product(name: "Peas", priceInUSD: 1.55)
        let currency = Currency(abbreviation: "EUR", name: "Euro", conversionRate: 2.0)

        XCTAssertTrue(pricingService.price(of: product, in: currency) == 1.55 * 2.0)
    }
}
