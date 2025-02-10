//
//  Untitled.swift
//  TransactionsTestTask
//
//  Created by Kostiantyn Antoniuk on 07.02.2025.
//

import Foundation

struct BitcoinRateResponseEntity: Codable {
    struct Bpi: Codable {
        struct Currency: Codable {
            let rateFloat: Double
            
            enum CodingKeys: String, CodingKey {
                case rateFloat = "rate_float"
            }
        }
        let usd: Currency
        
        enum CodingKeys: String, CodingKey {
            case usd = "USD"
        }
    }
    
    let bpi: Bpi
}
