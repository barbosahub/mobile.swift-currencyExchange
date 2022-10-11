//
//  CurrencyResult.swift
//  currencyConverter
//
//  Created by Rui Barbosa da Silva Junior on 10/10/22.
//

import UIKit

struct CurrencyResult: Codable {
    var date: String
    var info: Info
    var query: Query
    var result: Double
    var success: Bool
}

struct Info: Codable{
    var rate: Double
    var timestamp: Int
}

struct Query: Codable{
    var amount: Int
    var from: String
    var to: String
}
