//
//  TransactionEntity.swift
//  TransactionsTestTask
//
//  Created by Kostiantyn Antoniuk on 06.02.2025.
//

import Foundation

struct TransactionEntity {
    var id: UUID?
    var date: Date?
    var amount: Double?
    var category: String?
    var statusRaw: String?
    let curencyCode: String = "BTC"
    
    var status: TransactionStatus? {
        TransactionStatus(rawValue: statusRaw ?? "")
    }
    
    init(id: UUID?, date: Date?, amount: Double?, category: String?, statusRaw: String?) {
        self.id = id
        self.date = date
        self.amount = amount
        self.category = category
        self.statusRaw = statusRaw
    }
    
    init(object: TransactionObject) {
        self.id = object.id
        self.date = object.date
        self.amount = object.amount
        self.category = object.category
        self.statusRaw = object.statusRaw
    }
    
}

extension TransactionEntity {
    static var stub = TransactionEntity(id: .init(),
                                        date: Date(),
                                        amount: 123,
                                        category: "category",
                                        statusRaw: "income")
}

enum TransactionStatus: String {
    case income
    case expense
}
