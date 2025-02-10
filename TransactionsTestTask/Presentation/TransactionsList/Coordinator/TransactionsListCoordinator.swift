//
//  TransactionsListCoordinator.swift
//  TransactionsTestTask
//
//  Created by Kostiantyn Antoniuk on 05.02.2025.
//

import UIKit

protocol TransactionsListNaigationHandler {
    func start()
    func showAddTransactionScreen()
    func showAddFundsAlert(_ completion: @escaping (Double) -> Void)
}

final class TransactionsListCoordinator: TransactionsListNaigationHandler {
    
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let model = TransactionsListModelImpl()
        let viewModel = TransactionsListViewModelImpl(model: model, navigationHandler: self)
        let transactionsListViewController = TransactionsListViewController(viewModel: viewModel)
        navigationController.pushViewController(transactionsListViewController, animated: true)
    }

    func showAddTransactionScreen() {
        // TODO: - Show add transaction screen
    }
    
    func showAddFundsAlert(_ completion: @escaping (Double) -> Void) {
        let alertController = UIAlertController(
            title: "Add Funds",
            message: "Enter the amount of BTC to add",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = "Amount in BTC"
            textField.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let text = alertController.textFields?.first?.text,
               let amount = Double(text) {
                completion(amount)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.navigationController.present(alertController, animated: true, completion: nil)
        }
    }
}
