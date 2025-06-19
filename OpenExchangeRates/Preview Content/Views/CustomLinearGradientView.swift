//
//  CustomLinearGradientView.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 20/10/24.
//

import SwiftUI

struct CustomLinearGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.green.opacity(0.8),
                Color.mint,
                Color.teal,
                Color.green.opacity(0.4)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    CustomLinearGradientView()
}
