//
//  ContentView+ExchangeRatesView.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 21/10/24.
//

import Foundation
import SwiftUI

extension ContentView {
    func currencyListView(with list: [String]) -> some View {
        List(list, id: \.self) { value in
            if let exchangedModel = viewModel.getConvertedModel(for: value) {
                ExchangeRatesCell(model: exchangedModel)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                    .cornerRadius(8)
                    .padding(.vertical, 4)
            }
        }
        .listStyle(.plain)
        .gesture(
            DragGesture().onChanged({ _ in
                hideKeyboard()
            })
        )
        .scrollContentBackground(.hidden)
    }
}
