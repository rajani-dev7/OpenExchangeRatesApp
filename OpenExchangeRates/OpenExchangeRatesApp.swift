//
//  OpenExchangeRatesApp.swift
//  OpenExchangeRates
//
//  Created by Rajini's Macbook Pro  on 16/06/2025.
//

import SwiftUI

@main
struct OpenExchangeRatesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ExchangeRatesViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
