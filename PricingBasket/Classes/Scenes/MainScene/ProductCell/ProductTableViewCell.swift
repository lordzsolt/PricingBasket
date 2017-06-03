//
//  ProductTableViewCell.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/4/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit
import EasyPeasy

class ProductTableViewCell: UITableViewCell {
    static private var inset: CGFloat = 20
    static private var spacing: CGFloat = 8

    private var productLabel = UILabel()
    private var priceLabel = UILabel()
    private var countLabel = UILabel()
    private var stepper = UIStepper()

    public var viewModel: ProductCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            productLabel.text = viewModel.name
            priceLabel.text = viewModel.priceText
            countLabel.text = viewModel.countText
            stepper.value = Double(viewModel.count)
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        priceLabel.font = UIFont.systemFont(ofSize: 12)

        contentView.addSubview(productLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(stepper)

        stepper.maximumValue = 1000
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)

        productLabel <- [
            Top(ProductTableViewCell.spacing),
            Leading(ProductTableViewCell.inset),
            Trailing(ProductTableViewCell.spacing).to(countLabel)
        ]

        priceLabel <- [
            Top(ProductTableViewCell.spacing).to(productLabel),
            Bottom(ProductTableViewCell.spacing),
            Leading().to(productLabel, .leading),
            Trailing(>=ProductTableViewCell.inset).to(countLabel)
        ]

        countLabel <- [
            Top(ProductTableViewCell.spacing),
            Bottom(ProductTableViewCell.spacing),
            Trailing(ProductTableViewCell.inset).to(stepper)
        ]

        countLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        countLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)

        stepper <- [
            CenterY(),
            Right(ProductTableViewCell.inset)
        ]
    }

    override func prepareForReuse() {
        productLabel.text = nil
        countLabel.text = String(0)
        stepper.value = 0.0
    }

    func stepperValueChanged() {
        viewModel?.count = Int(stepper.value)
        countLabel.text = viewModel?.countText
    }
}
