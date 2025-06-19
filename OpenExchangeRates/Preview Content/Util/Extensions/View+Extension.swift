//
//  View+Extension.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 21/10/24.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
}

extension View {
    var decimalViewStyle : some View {
        self
            .modifier(DecimalTextFieldModifier())
    }
}
