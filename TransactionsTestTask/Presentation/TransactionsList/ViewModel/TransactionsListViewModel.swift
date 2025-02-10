//
//  TransactionsListViewModel.swift
//  TransactionsTestTask
//
//  Created by Kostiantyn Antoniuk on 05.02.2025.
//

import Foundation
import Combine

protocol TransactionsListViewModel {
    var numberOfRowsInSection: Int { get }
    var reloadDataPublisher: AnyPublisher<Void, Never> { get }

    func topUpBalanceAction()
    func addTransactionAction()
    func cellForRowAt(_ indexPath: IndexPath) -> TransactionEntity
}

final class TransactionsListViewModelImpl: TransactionsListViewModel {
    
    var numberOfRowsInSection: Int {
        return transactions.count
    }
    
    var reloadDataPublisher: AnyPublisher<Void, Never> {
        reloadData.eraseToAnyPublisher()
    }
    
    private let model: TransactionsListModel
    private let navigationHandler: TransactionsListNaigationHandler
    
    private(set) var transactions: [TransactionEntity] = []
    private let reloadData = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(model: TransactionsListModel, navigationHandler: TransactionsListNaigationHandler) {
        self.model = model
        self.navigationHandler = navigationHandler
        
        initializeBindings()
    }
    
    func topUpBalanceAction() {
        navigationHandler.showAddFundsAlert { [weak self] amount in
            self?.model.topUpBalance(by: amount)
        }
    }
    
    func addTransactionAction() {
        // TODO: - Handle add transaction action
        print("KA: addTransactionAction")
    }
    
    func cellForRowAt(_ indexPath: IndexPath) -> TransactionEntity {
        transactions[indexPath.row]
    }
}

// MARK: - Private methods
private extension TransactionsListViewModelImpl {
    func initializeBindings() {
        model.transactionsPublisher.sink { [weak self] transactions in
            self?.transactions = transactions
            self?.reloadData.send()
        }.store(in: &cancellables)
    }
}
