//
//  UserDefault+PropertyWrapper.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 21/10/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    
    var wrappedValue: T? {
        get {
            UserDefaults.standard.value(forKey: key) as? T
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

