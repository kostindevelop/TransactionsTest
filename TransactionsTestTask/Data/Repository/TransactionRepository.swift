//
//  TransactionRepository.swift
//  TransactionsTestTask
//
//  Created by Kostiantyn Antoniuk on 07.02.2025.
//

import CoreData
import Combine

protocol TransactionRepositoryProtocol {
    var transactionsPublisher: Published<[TransactionEntity]>.Publisher { get }
    func saveTransaction(transaction: TransactionEntity)
    func fetchTransactions()
}

final class TransactionRepository: TransactionRepositoryProtocol {
    
    @Published private var transactions: [TransactionEntity] = []

    var transactionsPublisher: Published<[TransactionEntity]>.Publisher { $transactions }
    
    func saveTransaction(transaction: TransactionEntity) {
        let object = TransactionObject(context: PersistentStorage.shared.context)
        object.id = transaction.id
        object.amount = transaction.amount ?? 0
        object.category = transaction.category
        object.date = transaction.date
        object.statusRaw = transaction.statusRaw
        
        PersistentStorage.shared.saveContext()
        fetchTransactions()
    }
    
    
    func fetchTransactions() {
        let records = PersistentStorage.shared.fetchManagedObject(managedObject: TransactionObject.self)
        guard let records, !records.isEmpty else { return }
        transactions = records.compactMap { TransactionEntity(object: $0) }
    }
}
