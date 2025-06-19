//
//  Date+Extension.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 19/10/24.
//

import Foundation

extension Date {
    
    /// Method will provide the current date in the required format
    /// - Parameter format: format
    /// - Returns: Date in string format
    func getString(format: String = "E, d MMM yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
