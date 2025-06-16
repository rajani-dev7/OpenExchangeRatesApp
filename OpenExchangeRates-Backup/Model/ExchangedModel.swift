//
//  ExchangedModel.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 19/10/24.
//

import Foundation

struct ExchangedModel: Hashable {
    var countryName: String
    var amount: String
    var countryId: String
    var exchangeRate: String?
    var id = UUID()
}
