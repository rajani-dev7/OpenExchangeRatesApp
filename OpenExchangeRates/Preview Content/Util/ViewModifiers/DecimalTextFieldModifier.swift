//
//  DecimalTextFieldModifier.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 19/10/24.
//

import Foundation
import SwiftUI

struct DecimalTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .keyboardType(.decimalPad)
        .textFieldStyle(.roundedBorder)
        .padding(.leading, 16)
        .padding(.vertical,16)
        .submitLabel(.done)
    }
}
