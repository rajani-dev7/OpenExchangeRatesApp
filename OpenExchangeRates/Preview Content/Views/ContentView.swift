//
//  ContentView.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 18/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ExchangeRatesViewModel
   
    var body: some View {
        NavigationView {
            if !viewModel.showSplashScreen {
                ZStack {
                    CustomLinearGradientView()
                    VStack(alignment: .leading, spacing: 0) {
                        if let countriesList = viewModel.countriesList {
                            // Last updated time stamp
                            Text(viewModel.lastUpdatedTimeStamp)
                                .padding(.leading, 16)
                            // Currency selector view along with text field
                            self.currencySelectorView(with: countriesList)
                            // Currency list view.
                            if let filteredCountriesList = viewModel.filteredCountriesList {
                                self.currencyListView(with: filteredCountriesList)
                            }
                        } else {
                            VStack {
                                ProgressView()
                                Text(viewModel.fetchTitle)
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .alert(viewModel.errorTitle, isPresented: $viewModel.showError, actions: {
                        Button(viewModel.retryTitle) {
                            Task {
                                await viewModel.fetchData()
                            }
                        }
                    }, message: {
                        Text(viewModel.errorMessage)
                    })
                    .searchable(text: $viewModel.searchText)
                }
                .navigationTitle(viewModel.navigationBarTitle)
                .onTapGesture {
                    hideKeyboard()
                }
            } else {
                ZStack {
                    CustomLinearGradientView()
                    VStack {
                        Image("SplashScreen")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                        Text(viewModel.splashScreenTitle)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            Task {
                await viewModel.fetchData()
            }
        }
    }
}

#Preview {
    ContentView(viewModel: ExchangeRatesViewModel())
}
