//
//  RootCoordinator.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit

class RootCoordinator: Coordinator {
    private var window: UIWindow
    private var navigationController: UINavigationController?

    init(with window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewController = MainViewController()
        navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
    }
}
