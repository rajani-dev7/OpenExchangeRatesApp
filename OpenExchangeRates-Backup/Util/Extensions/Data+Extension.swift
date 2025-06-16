//
//  Data+Extension.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 18/10/24.
//

import Foundation

extension Data {
    func jsonObject() -> Result<Any, Error> {
        do {
            let obj = try JSONSerialization.jsonObject(with: self, options: .init(rawValue: 0))
            return .success(obj)
        }
        catch {
            return .failure(error)
        }
    }
}
