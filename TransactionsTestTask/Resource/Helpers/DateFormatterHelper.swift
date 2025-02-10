//
//  DateFormatterHelper.swift
//  TransactionsTestTask
//
//  Created by Kostiantyn Antoniuk on 07.02.2025.
//

import Foundation

final class DateFormatterHelper {
    
    static let shared = DateFormatterHelper()
    
    private let calendar = Calendar.current
    private let formatter: DateFormatter

    private init() {
        formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
    }

    func formatDate(_ date: Date?, format: String = "dd MMM YYYY HH:mm") -> String {
        guard let date else { return "" }
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return "Today at \(formatter.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            formatter.dateFormat = "HH:mm"
            return "Yesterday at \(formatter.string(from: date))"
        } else {
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
    }
}
