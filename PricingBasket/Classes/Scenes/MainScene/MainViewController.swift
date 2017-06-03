//
//  MainViewController.swift
//  PricingBasket
//
//  Created by Zsolt Kovacs on 6/3/17.
//  Copyright © 2017 iOSmith. All rights reserved.
//

import UIKit
import EasyPeasy

class MainViewController: UITableViewController {
    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.MainScene.screenTitle

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.MainScene.checkoutButton, style: .done, target: self, action: #selector(checkoutButtonTapped))

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        viewModel.viewDelegate = self
    }

    func checkoutButtonTapped() {
        viewModel.checkoutButtonTapped()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.productViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseIdentifier) as! ProductTableViewCell
        cell.viewModel = viewModel.productViewModels[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension MainViewController: MainViewModelViewDelegate {
    func viewModelDidUpdateProducts(_ viewModel: MainViewModel) {
        tableView.reloadData()
    }

    func errorOccurect(in viewModel: MainViewModel, message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Strings.General.ok, style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
