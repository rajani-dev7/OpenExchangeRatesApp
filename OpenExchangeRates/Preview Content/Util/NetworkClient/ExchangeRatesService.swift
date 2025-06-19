//
//  ExchangeRatesService.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 18/10/24.
//

import Foundation

class ExchangeRatesService: NetworkService {
    
    /// Asynchronously fetches exchange rates from an external API and returns the parsed data.
    /// - Throws: An error if the API request fails, the data cannot be decoded, or the response is invalid.Errors can include network failures, decoding errors, or unexpected API responses.
    /// - Returns: An optional `ExchangeRateModel`. If the request succeeds, the model contains the fetched exchange rates. If the data is unavailable, the function returns `nil`.
    func fetchExchangeRates() async throws -> ExchangeRateModel? {
        guard let url = URLConfigurations.shared.url(for: .exchangeRateUrl) else {
            throw APIClientError.badUrl
        }
        return try await self.fetchResponse(for: url).get() as? ExchangeRateModel
    }
    
    /// Parses the API response data and decodes it into an `ExchangeRateModel`.This method attempts to decode the given `Data` into a `ExchangeRateModel` using `JSONDecoder`. If the decoding is successful and the API call condition (`shouldCallAPI`) is met, it stores the timestamp of the last successful API call for tracking.
    /// - Parameter responseData: The raw `Data` received from the API response.
    /// - Returns: An `APIResult` containing either a successful `ExchangeRateModel` or a failure with an associated `Error`.
    /// - Throws: This method does not explicitly throw errors but wraps decoding failures in the `.failure` case of `APIResult`.
    override func parseResponseData(_ responseData: Data) -> APIResult {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(ExchangeRateModel.self, from: responseData)
            if self.shouldCallAPI {
                APITimerService().storeLastAPICallTime()
            }
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
}
