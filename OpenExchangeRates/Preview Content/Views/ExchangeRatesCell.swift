//
//  ExchangeRatesCell.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 19/10/24.
//

import SwiftUI

struct ExchangeRatesCell: View {
    var model: ExchangedModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.5), radius: 5, x: 2, y: 2)
            VStack {
                HStack {
                    Text(model.countryName)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                    Text(model.amount)
                        .transition(.move(edge: .trailing))
                        .foregroundColor(.gray)
                        .animation(.spring(), value: model.id)
                }
                
                HStack {
                    Text(model.countryId)
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                HStack {
                    Text(model.exchangeRate ?? "")
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    ExchangeRatesCell(model: ExchangedModel(countryName: "United states", amount: "123", countryId: "USD"))
}
