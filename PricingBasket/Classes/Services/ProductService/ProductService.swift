//
//  ProductService.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/4/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Service for loading products
class ProductService {
    func loadProducts(_ completion: @escaping (Response<JSON>) -> Void) {

        // Load mock products for now. Replace with server call if needed
        let peas: [String: Any] = [ProductServiceConstants.Keys.name: "Peas", ProductServiceConstants.Keys.price: 0.95]
        let eggs: [String: Any] = [ProductServiceConstants.Keys.name: "Eggs", ProductServiceConstants.Keys.price: 2.10]
        let milk: [String: Any] = [ProductServiceConstants.Keys.name: "Milk", ProductServiceConstants.Keys.price: 1.30]
        let beans: [String: Any] = [ProductServiceConstants.Keys.name: "Beans", ProductServiceConstants.Keys.price: 0.73]

        let products = JSON([peas, eggs, milk, beans])
        completion(.success(products))
    }
}
