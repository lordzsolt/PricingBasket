//
//  RootCoordinator.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit

class RootCoordinator: Coordinator {
    fileprivate var window: UIWindow
    fileprivate var navigationController: UINavigationController?

    fileprivate let currencyService = CurrencyService(apiKey: Constants.CurrencyLayerApiKey, sourceCurrencyAbbreviation: Strings.General.defaultCurrencyAbbreviation)
    fileprivate lazy var pricingService = PricingService()

    fileprivate var mainViewModel: MainViewModel?

    init(with window: UIWindow) {
        self.window = window
    }

    func start() {
        let mainViewModel = MainViewModel(productService: ProductService())
        mainViewModel.coordinator = self
        self.mainViewModel = mainViewModel

        let viewController = MainViewController(viewModel: mainViewModel)
        navigationController = ReachabilityNavigationController(rootViewController: viewController)
        navigationController?.navigationBar.isTranslucent = false
        window.rootViewController = navigationController
    }
}

extension RootCoordinator: MainViewModelCoordinatorDelegate {
    func didSelectCheckout(_ viewModel: MainViewModel, with cart: Cart) {
        let detailViewModel = DetailViewModel(cart: cart, pricingService: pricingService, currencyService: currencyService)
        
        let viewController = DetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
