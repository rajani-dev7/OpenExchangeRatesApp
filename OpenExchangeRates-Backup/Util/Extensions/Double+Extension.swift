//
//  Double+Extension.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 19/10/24.
//

import Foundation
    
extension Double {
    
    /// Returns the rounded value of the double in String format based on the precision type.
    /// - Parameter places: The number of decimal places to round to (default is 2).
    /// - Returns: The rounded value as a String.
    func roundedValue(toPlaces places: Int = 2) -> String {
        let precision = URLConfigurations.shared.urlConfigs?.precisionType ?? .floor
        switch precision {
        case .ceil:
            let value =  self.ceil(toPlaces: places)
            return String(format: "%.2f", value)
        case .floor:
            let value = self.floor(toPlaces: places)
            return String(format: "%.2f", value)
        }
    }
    
    /// Rounds the value up to the specified number of decimal places.
    /// - Parameter places: Number of decimal places (default is 2).
    /// - Returns: Ceil-rounded Double value.
    private func ceil(toPlaces places: Int = 2) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.up) / divisor
    }
    
    /// Rounds the value down to the specified number of decimal places.
    /// - Parameter places: Number of decimal places (default is 2).
    /// - Returns: Floor-rounded Double value.
    private func floor(toPlaces places: Int = 2) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded(.down) / divisor
    }
}

