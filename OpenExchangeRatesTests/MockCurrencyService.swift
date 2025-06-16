//
//  MockCurrencyService.swift
//  OpenExchangeRatesTests
//
//  Created by Rajani Bhimanadam on 19/10/24.
//

import Foundation
@testable import OpenExchangeRates

class MockCurrencyService: CurrencyListService {
    var mockCurrencies: [String: String] = [:]
    var shouldReturnError: Bool = false

    override func fetchCurrencies() async throws -> [String: String] {
        if shouldReturnError {
            throw NSError(domain: "Fetch Error", code: 0, userInfo: nil)
        }
        return mockCurrencies
    }
}
