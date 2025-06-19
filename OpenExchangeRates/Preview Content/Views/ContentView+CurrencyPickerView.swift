//
//  ContentView+CurrencyPickerView.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 21/10/24.
//

import Foundation
import SwiftUI

extension ContentView {
    
    func currencySelectorView(with list:[String]) -> some View {
        HStack {
            // Textfield to enter the amount
            TextField(viewModel.textFieldPlaceHolder, text: $viewModel.amount)
                .decimalViewStyle
            Picker(viewModel.countrySelectionTitle, selection: $viewModel.selectedCountry) {
                ForEach(list, id:\.self) { key in
                    Text(key)
                        .tag(key)
                    
                }
                .padding(.trailing, 12)
            }
            .tint(.black)
        }
    }
}
