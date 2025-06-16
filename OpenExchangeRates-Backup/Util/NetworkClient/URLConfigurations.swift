//
//  URLConfigurations.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 18/10/24.
//

import Foundation


final class URLConfigurations {
    
    static let shared = URLConfigurations()
    private(set) var urlConfigs: URLConfigs?
    
    private init() {
        self.fetchConfigs()
    }
    
    /// Method will fetch configs based on the config file included in the project.
    private func fetchConfigs() {
        guard let fileUrl = Bundle.main.url(forResource: "Config", withExtension: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: fileUrl)
            self.urlConfigs = try JSONDecoder().decode(URLConfigs.self, from: data)
        } catch {
            return
        }
    }
    
    /// Constructs a URL based on the provided URL type and optional query parameters.
    /// - Parameters:
    ///   - type:  A `URLType` enum value that specifies the type of URL to generate.This could represent different endpoints or API routes within your app.
    ///   - queryItems: An optional dictionary of query parameters to append to the URL,where the key is the parameter name and the value is its value.Default is `nil` (no query items).
    /// - Returns: A fully constructed `URL` if valid, or `nil` if the URL cannot be formed.
    func url(for type: URLType, queryItems: [String: String]? = nil) -> URL? {
        self.urlConfigs?.getUrl(of: type, queryItems: queryItems)
    }
}
