//
//  URLRequest+Extension.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 20/10/24.
//

import Foundation

extension URLRequest {
    
    /// Will provide the stored cached response based on the URLRequest
    var cachedResponse: (response: URLResponse?, data: Data?) {
        let cachedResponse = URLCache.shared.cachedResponse(for: self)
        return (cachedResponse?.response, cachedResponse?.data)
    }
    
    
    /// Method will store the url response and data for the URLRequest
    /// - Parameters:
    ///   - response: URLResponse
    ///   - data: Data
    func storeCache(response: URLResponse, data: Data) {
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: self)
    }
}
