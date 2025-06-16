//
//  APITimerSettings.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 21/10/24.
//

import Foundation

struct TimerSettings {
    static let lastAPICallKey = "lastAPICallTime"
    
    @UserDefault(key: TimerSettings.lastAPICallKey)
    var value: Double?
}
