//
//  MainViewModel.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/4/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import Foundation

class MainViewModel {
    public weak var coordinator: MainViewModelCoordinatorDelegate?
    public weak var viewDelegate: MainViewModelViewDelegate?
    public var productViewModels: [ProductCellViewModel] = []

    private var products: [Product] = [] {
        didSet {
            productViewModels = products.flatMap { product in
                return ProductCellViewModel(product: product)
            }
            DispatchQueue.main.async {
                self.viewDelegate?.viewModelDidUpdateProducts(self)
            }
        }
    }

    private let productService: ProductService

    init(productService: ProductService) {
        self.productService = productService

        self.productService.loadProducts { [weak self] response in
            switch response {
            case .success(let json): self?.products = Product.products(from: json)
            case .failure(let message):
                DispatchQueue.main.async {
                    self?.viewDelegate?.errorOccurect(in: self!, message: message)
                }
            }
        }
    }

    func checkoutButtonTapped() {
        let cart = constructCart()
        if cart.content().isEmpty {
            viewDelegate?.errorOccurect(in: self, message: Strings.ErrorMessage.cartIsEmpty)
        }
        else {
            coordinator?.didSelectCheckout(self, with: cart)
        }
    }

    private func constructCart() -> Cart {
        var cart = Cart()
        let boughtProducts = zip(productViewModels, products).filter{ (viewModel, _) -> Bool in
            return viewModel.count > 0
        }

        for (viewModel, product) in boughtProducts {
            cart.add(product, number: viewModel.count)
        }

        return cart
    }
}

protocol MainViewModelViewDelegate: class {
    func viewModelDidUpdateProducts(_ viewModel: MainViewModel)
    func errorOccurect(in viewModel: MainViewModel, message: String)
}

protocol MainViewModelCoordinatorDelegate: class {
    func didSelectCheckout(_ viewModel: MainViewModel, with cart: Cart)
}
