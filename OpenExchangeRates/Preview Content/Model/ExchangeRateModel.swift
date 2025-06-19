//
//  ExchangeRateModel.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 18/10/24.
//

import Foundation

struct ExchangeRateModel: Codable {
    var base: String?
    var rates: [String: Double]?
}
