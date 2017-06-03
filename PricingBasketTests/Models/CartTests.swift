//
//  CartTests.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import XCTest
@testable import PricingBasket

class CartTests: XCTestCase {
    func testCartIsCreatedEmpty() {
        let cart = Cart()
        let content = cart.content()
        XCTAssertTrue(content.isEmpty)
    }

    func testCanAddOneProduct() {
        var cart = Cart()
        let product = Product(name: "Peas", priceInUSD: 1.0)
        cart.add(product)

        XCTAssertTrue(cart.numberOf(product) == 1)
    }

    func testCanAddMultipleProducts() {
        var cart = Cart()
        let product = Product(name: "Peas", priceInUSD: 1.0)

        cart.add(product, number: 3)

        XCTAssertTrue(cart.numberOf(product) == 3)
    }

    func testCanRemove() {
        var cart = Cart()
        let product = Product(name: "Peas", priceInUSD: 1.0)

        cart.add(product, number: 3)
        cart.remove(product, number: 2)

        XCTAssertTrue(cart.numberOf(product) == 1)
    }

    func testCanRemoveAllProducts() {
        var cart = Cart()
        let product = Product(name: "Peas", priceInUSD: 1.0)

        cart.add(product, number: 3)
        cart.removeAll(product)

        XCTAssertTrue(cart.numberOf(product) == 0)
    }

    func testCanEmptyCart() {
        var cart = Cart()
        let productOne = Product(name: "Peas", priceInUSD: 1.0)
        let productTwo = Product(name: "Beans", priceInUSD: 2.0)


        cart.add(productOne, number: 2)
        cart.add(productTwo)

        cart.empty()

        XCTAssertTrue(cart.content().isEmpty)
    }

    func testRemovingOneProductNotAffectingOther() {
        var cart = Cart()
        let productOne = Product(name: "Peas", priceInUSD: 1.0)
        let productTwo = Product(name: "Beans", priceInUSD: 2.0)


        cart.add(productOne, number: 2)
        cart.add(productTwo)

        cart.removeAll(productOne)

        XCTAssertTrue(cart.numberOf(productTwo) == 1)
    }

    func testCantRemoveBeyondZero() {
        var cart = Cart()
        let product = Product(name: "Peas", priceInUSD: 1.0)

        cart.remove(product)

        XCTAssertTrue(cart.numberOf(product) == 0)
    }
}
