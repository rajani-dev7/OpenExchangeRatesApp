//
//  APITimerValidator.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 18/10/24.
//

import Foundation

class APITimerService {
    
    var timerSettings = TimerSettings()
    
    /// Will provide the last api call time in time interval format
    var getLastAPICallTime: TimeInterval? {
        timerSettings.value
    }
    
    /// provides the last api date in Date format
    private var lastAPICallDate: Date? {
        guard let getLastAPICallTime else { return Date() }
       return  Date(timeIntervalSince1970: getLastAPICallTime)
    }
    
    /// provides the last api time in string format
    var lastAPITimeString: String? {
        return lastAPICallDate?.getString()
    }
    
    /// provides the interval of next fetch call.
    var nextFetchInterval: TimeInterval {
        let lastFetchTime = APITimerService().lastAPICallDate
        let nextFetchTime = (lastFetchTime ?? Date()).addingTimeInterval(1800)
        let interval = max(0, nextFetchTime.timeIntervalSinceNow)
        return interval
    }
    
    /// stores the current Date into user defaults
    func storeLastAPICallTime(date: Date = Date()) {
        let timeStamp = date.timeIntervalSince1970
        timerSettings.value = timeStamp
    }
    
}
