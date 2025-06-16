//
//  UrlConfigs.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 20/10/24.
//

import Foundation

struct URLConfigs: Codable {
    
    var appId: String
    var apiKey: String
    var baseUrl: String
    var currenciesPath: String
    var exchangeRatesPath: String
    var precisionType: PrecisionType = .floor
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.appId = try container.decode(String.self, forKey: .appId)
        self.apiKey = try container.decode(String.self, forKey: .apiKey)
        self.baseUrl = try container.decode(String.self, forKey: .baseUrl)
        self.currenciesPath = try container.decode(String.self, forKey: .currenciesPath)
        self.exchangeRatesPath = try container.decode(String.self, forKey: .exchangeRatesPath)
        let type = try container.decode(String.self, forKey: .precisionType)
        self.precisionType = PrecisionType(rawValue: type) ?? .floor
    }
    
    /// will create the url based on the requested type and will include the url components to the URL
    /// - Parameters:
    ///   - type: URLType
    ///   - queryItems: URLQuery items
    /// - Returns: will provide the parsed URL
    func getUrl(of type: URLType, 
                queryItems: [String: String]? = nil) -> URL? {
        let path = self.getUrl(for: type)
        guard var components = URLComponents(string: path) else {
            return nil
        }
        if let queryItems {
            components.queryItems = queryItems.map({ key, value in
                URLQueryItem(name: key, value: value)
            })
        } else {
            components.queryItems = [URLQueryItem(name: appId, value: apiKey)]
        }
        return components.url
    }
    
    /// method will include the base path along with json path fetched from the config file
    /// - Parameter type: URLType
    /// - Returns: returns the url path based on the URLType
    private func getUrl(for type: URLType) -> String {
        var path = ""
        switch type {
        case .currency:
            path = baseUrl + currenciesPath
        case .exchangeRateUrl:
            path = baseUrl + exchangeRatesPath
        }
        return path
    }
    
}
