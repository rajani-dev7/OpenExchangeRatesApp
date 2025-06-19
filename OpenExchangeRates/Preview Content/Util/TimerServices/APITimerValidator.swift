//
//  APITimerValidator.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 18/10/24.
//

import Foundation

class APITimerValidator {
    
    /// will calculate the time difference if it is more than 30 minutes then it will return true otherwise false
    /// - Returns: boolean value indicating whether the interval is expired or not.
    func shouldCallAPI() -> Bool {
        let currentTime = Date().timeIntervalSince1970
        guard let lastCallTime = APITimerService().getLastAPICallTime else {
            return true
        }
        return (currentTime - lastCallTime) >= (1800)
    }
}
