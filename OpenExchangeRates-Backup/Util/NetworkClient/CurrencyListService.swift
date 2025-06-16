//
//  CurrencyListService.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 18/10/24.
//

import Foundation

class CurrencyListService: NetworkService {
    
    /// Will fetch the list of currencies along with the country code.
    /// - Returns: dictionary with currency code and country name
    func fetchCurrencies() async throws -> [String: String]? {
        guard let url = URLConfigurations.shared.url(for: .currency) else {
            throw APIClientError.badUrl
        }
        return try await self.fetchResponse(for: url).get() as? [String: String]
    }
    
    /// method will parse the response data
    /// - Parameter responseData: Data
    /// - Returns: APIResult with success  type as list of country code and country names and failure type as error
    override func parseResponseData(_ responseData: Data) -> APIResult {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode([String: String].self, from: responseData)
            return .success(result)
        } catch {
            return .failure(APIClientError.decodingError)
        }
    }
}
