//
//  DetailViewController.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/4/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit
import EasyPeasy

class DetailViewController: UIViewController {
    static var inset: CGFloat = 20

    fileprivate let viewModel: DetailViewModel
    private let totalLabel = UILabel()
    fileprivate let priceLabel = UILabel()
    fileprivate let currencyField = CurrencyTextField()
    private let pickerView = UIPickerView()
    private let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        viewModel.viewDelegate = self
        viewModel.loadingStateCallback = { [weak self] isLoading in
            guard let `self` = self else {
                return
            }

            self.currencyField.isUserInteractionEnabled = !isLoading
            self.loadingIndicator.isHidden = !isLoading;
            if isLoading {
                self.loadingIndicator.startAnimating()
            }
            else {
                self.loadingIndicator.stopAnimating()
                self.pickerView.reloadAllComponents()

                self.pickerView.selectRow(self.viewModel.initiallySelectedCurrencyIndex, inComponent: 0, animated: false)
            }
        }
    }

    private func setupView() {
        title = Strings.DetailScene.screenTitle
        view.backgroundColor = UIColor.white

        totalLabel.text = Strings.DetailScene.totalLabel
        totalLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)

        priceLabel.text = viewModel.priceString
        priceLabel.textAlignment = .right

        currencyField.autocorrectionType = .no
        currencyField.text = viewModel.currencyAbbreviation
        currencyField.borderStyle = .roundedRect
        currencyField.textAlignment = .center

        pickerView.dataSource = self
        pickerView.delegate = self
        currencyField.inputView = pickerView

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doneButtonTapped))
        view.addGestureRecognizer(tapGesture)

        view.addSubview(totalLabel)
        view.addSubview(priceLabel)
        view.addSubview(currencyField)
        view.addSubview(loadingIndicator)

        totalLabel <- [
            Top(DetailViewController.inset),
            Leading(DetailViewController.inset)
        ]

        priceLabel <- [
            Top().to(totalLabel, .top),
            Leading(DetailViewController.inset).to(totalLabel)
        ]

        currencyField <- [
            FirstBaseline().to(totalLabel),
            Leading(DetailViewController.inset).to(priceLabel),
            Trailing(DetailViewController.inset),
            Width(80)
        ]

        loadingIndicator <- [
            Center()
        ]
    }

    @objc private func doneButtonTapped() {
        currencyField.resignFirstResponder()
    }
}

extension DetailViewController: DetailViewModelViewDelegate {
    func viewModelDidUpdateSelectedCurrency(_ viewModel: DetailViewModel) {
        currencyField.text = viewModel.currencyAbbreviation
        priceLabel.text = viewModel.priceString
    }


    func errorOccurect(in viewModel: DetailViewModel, message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.General.ok, style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.currencies?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = view as? UILabel ?? UILabel()

        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center

        if let currency = viewModel.currencies?[row] {
            label.text = "\(currency.abbreviation) - \(currency.name)"
        } else {
            label.text = ""
        }

        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectCurrency(at: row)
    }
}
