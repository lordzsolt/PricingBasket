//
//  Product.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Product {
    private(set) var name: String
    private(set) var priceInUSD: Float

    init(name: String, priceInUSD: Float) {
        self.name = name
        self.priceInUSD = priceInUSD
    }

    init(json: JSON) {
        let name = json[ProductServiceConstants.Keys.name].string ?? ""
        let priceInUSD = json[ProductServiceConstants.Keys.price].float ?? 0.0
        self.init(name: name, priceInUSD: priceInUSD)
    }

    static func products(from json: JSON) -> [Product] {
        return json.flatMap { (_, json) -> Product in
            return Product(json: json)
        }
    }
}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Product: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}
