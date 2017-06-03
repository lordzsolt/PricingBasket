//
//  ReachabilityNavigationController.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/5/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit
import ReachabilitySwift
import EasyPeasy

class ReachabilityNavigationController: UINavigationController {

    // These too properties can't be constantly initialized here, because UINavigationController is leaking. See blog post: http://darrarski.pl/2014/12/not-initialize-objects-swift/
    private var reachability: Reachability?
    private var errorView: FooterErrorView?
    
    private var isReachable: Bool = true {
        didSet {
            DispatchQueue.main.async {
                self.errorView?.easy_reload()
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let errorView = FooterErrorView()
        errorView.errorMessage = Strings.General.noInternetConnection
        view.addSubview(errorView)
        errorView <- [
            Bottom(),
            Leading(),
            Trailing(),
            Height(0).when { [weak self] in
                return self?.isReachable ?? false
            }
        ]

        let reachability = Reachability()
        reachability?.whenReachable = { [weak self] _ in
            self?.isReachable = true
        }

        reachability?.whenUnreachable = { [weak self] _ in
            self?.isReachable = false
        }

        self.reachability = reachability

        do {
            try reachability?.startNotifier()
        }
        catch {
            print("Failed to start reachability. Network status unknown")
        }
    }
}
