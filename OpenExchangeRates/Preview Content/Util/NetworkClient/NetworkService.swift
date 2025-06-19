//
//  NetworkService.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 18/10/24.
//

import Foundation

typealias APIResult = Result<Any?,Error>

class NetworkService: NSObject {
    
    private var timeoutInterval: TimeInterval = 60
    
    /// Variable for boolean value to call the API or not.
    var shouldCallAPI: Bool {
        APITimerValidator().shouldCallAPI()
    }
    
    /// Intialiser
    /// - Parameter timeoutInterval: time out interval for url request
    public init(_ timeoutInterval:TimeInterval? = nil) {
        super.init()
        self.timeoutInterval = timeoutInterval ?? self.timeoutInterval
    }
    
    /// method will set the request headers for URLRequest
    /// - Parameter request: request
    func setHeaders(request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    /// method will set the http body for URLRequest
    /// - Parameter request: request
    func setHTTPBody(request: inout URLRequest) {
        // over ride this method if any post data needed to add in request
    }
    
    /// Method will parse the response data into APIResult
    /// - Parameter responseData: response
    /// - Returns: APIResult with success  type as data and failure type as error
    func parseResponseData(_ responseData:Data) -> APIResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: .init(rawValue: 0))
            return .success(jsonObject)
        }
        catch {
            return .failure(error)
        }
    }
}

extension NetworkService {
    
    /// Method will fetch the response based on the url string
    /// - Parameters:
    ///   - url: url string
    ///   - method: http method for request type
    /// - Returns: APIResult with success  type as data and failure type as error
    func fetchResponse(for url: String,
                       method: HTTPMethod = .get) async throws -> APIResult {
        guard let url = URL(string: url) else {
            return .failure(APIClientError.badUrl)
        }
        return try await self.fetchResponse(for: url, method: method)
    }
    
    /// Method will fetch the response based on the url
    /// - Parameters:
    ///   - url: URL
    ///   - method: http method for request type
    /// - Returns: APIResult with success  type as data and failure type as error
    func fetchResponse(for url: URL,
                       method: HTTPMethod = .get) async throws -> APIResult {
        let request = self.createURLRequest(url, method: method)
        return try await self.fetchResponse(for: request)
    }
    
    /// Method will fetch the response based on the url request
    /// - Parameter request: URLRequest
    /// - Returns: APIResult with success  type as data and failure type as error
    private func fetchResponse(for request: URLRequest) async throws -> APIResult {
        guard self.shouldCallAPI else {
            return self.fetchCachedResponse(for: request)
        }
        let session = URLSession.shared
        do {
            let (data,response) = try await session.data(for: request)
            request.storeCache(response: response, data: data)
            return self.getResult(data, response)
        } catch {
            if let error = error as? URLError {
                if error.code == URLError.notConnectedToInternet {
                    return self.fetchCachedResponse(for: request)
                }
            }
            throw error
        }
    }
    
    /// Method will provide the cached response for the urlRequest
    /// - Parameter request: URLRequest for which user has requested for data
    /// - Returns: APIResult of data and response.
    private func fetchCachedResponse(for request: URLRequest) -> APIResult {
        let cachedResponse = request.cachedResponse
        return self.getResult(cachedResponse.data, cachedResponse.response)
    }
    
    /// Method will returns the updated url request by including the headers and http body
    /// - Parameters:
    ///   - url: URL
    ///   - method: http method
    /// - Returns: URLRequest
    private func createURLRequest(_ url:URL, method:HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        self.setHeaders(request: &request)
        self.setHTTPBody(request: &request)
        request.timeoutInterval = self.timeoutInterval
        request.httpMethod = method.rawValue
        return request
    }
}

extension NetworkService {
    
    /// method will return the result based on the data and url reponse
    /// - Parameters:
    ///   - data: Data
    ///   - response: URLResponse
    /// - Returns: APIResult with success  type as data and failure type as error
    private func getResult(_ data:Data?, _ response:URLResponse?) -> APIResult {
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
         
        if statusCode >= 400 && statusCode < 600 {
            return .failure(APIClientError.networkError)
        }
        
        guard let _data = data else { return .failure(APIClientError.dataError) }
        
        return self.parseResponseData(_data)
    }
}
