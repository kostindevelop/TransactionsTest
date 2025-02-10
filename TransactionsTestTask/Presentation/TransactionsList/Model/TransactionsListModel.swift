//
//  TransactionsListModel.swift
//  TransactionsTestTask
//
//  Created by Kostiantyn Antoniuk on 05.02.2025.
//

import Foundation
import Combine

protocol TransactionsListModel {
    var transactionsPublisher: AnyPublisher<[TransactionEntity], Never> { get }

    func topUpBalance(by amount: Double)
//    func fetchTransactions()
}

final class TransactionsListModelImpl: TransactionsListModel {
    
    var transactionsPublisher: AnyPublisher<[TransactionEntity], Never> {
        transactionsSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }

    private let repository: TransactionRepositoryProtocol
    
    private let transactionsSubject = CurrentValueSubject<[TransactionEntity], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: TransactionRepositoryProtocol = TransactionRepository()) {
        self.repository = repository
        
        subscribeToTransactions()
        fetchTransactions()
    }

    func topUpBalance(by amount: Double) {
        let transaction = TransactionEntity(id: .init(), date: Date(), amount: amount, category: "TopUp", statusRaw: "income")
        repository.saveTransaction(transaction: transaction)
    }
    
    func subscribeToTransactions() {
        repository.transactionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transactions in
                self?.transactionsSubject.value = transactions
            }
            .store(in: &cancellables)
    }
    
    private func fetchTransactions() {
        repository.fetchTransactions()
    }
}
