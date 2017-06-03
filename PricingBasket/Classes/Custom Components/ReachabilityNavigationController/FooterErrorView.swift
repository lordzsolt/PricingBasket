//
//  FooterErrorView.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/5/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit
import EasyPeasy

class FooterErrorView: UIView {
    public var errorMessage: String? {
        didSet {
            errorLabel.text = errorMessage
        }
    }

    private let errorLabel = UILabel()

    init() {
        super.init(frame: CGRect.zero)
        self.setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.black
        layer.masksToBounds = true

        errorLabel.textAlignment = .center
        errorLabel.textColor = UIColor.white
        errorLabel.numberOfLines = 0
        errorLabel.font = UIFont.systemFont(ofSize: 15)
        errorLabel.layer.masksToBounds = true

        addSubview(errorLabel)

        errorLabel <- [
            Edges(0)
        ]
    }
}
