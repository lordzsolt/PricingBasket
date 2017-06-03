//
//  CurrencyTextField.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/5/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit

class CurrencyTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
}
