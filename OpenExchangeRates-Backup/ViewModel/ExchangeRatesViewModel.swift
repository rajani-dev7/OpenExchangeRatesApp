//
//  ExchangeRatesViewModel.swift
//  OpenExchangeRates
//
//  Created by Rajani Bhimanadam on 18/10/24.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ExchangeRatesViewModel: ObservableObject {
    
    //MARK: - Published variables
    @Published var amount: String = "1"
    @Published var selectedCountry: String = "USD" {
        didSet { calculateExchangeRates(for: amount) }
    }
    @Published var countriesList: [String]?
    @Published var filteredCountriesList: [String]?
    @Published var convertedRates: [String: String] = [:]
    @Published var showError: Bool = false
    @Published var showSplashScreen = false
    @Published var searchText: String = ""
    
    //MARK: - private variables
    private(set) var errorMessage = ""
    private var anyCancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    
    //MARK: - Variables declaration
    var currenciesList: [String: String]?
    var currencyListService = CurrencyListService()
    var exchnageRateService = ExchangeRatesService()
    var exchangeRates: [String: Double]?
    
    private var interval: TimeInterval {
        APITimerService().nextFetchInterval
    }
    
    //MARK: - init method
    init() {
        setupPublisher()
        self.configureSplashScreen()
        Task {
            await self.fetchData()
        }
    }
    
    private func configureSplashScreen() {
        self.showSplashScreen = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showSplashScreen = false
        }
    }

    //MARK: - Method declarations
    
    /// Will fetch the data for currencies and exchange rates if there is any error then that error message will be stored and passed it to the view.
    func fetchData() async {
        do {
            let (currenciesListModel, exchangeRatesListModel) = try await fetchCurrenciesAndRates()
            processFetchedData(currencies: currenciesListModel, rates: exchangeRatesListModel)
        } catch {
            handleFetchError(error)
        }
    }
    
    /// Method will fetch currencies and rates
    /// - Returns: currencies list and exchange rate model
    private func fetchCurrenciesAndRates() async throws -> ([String: String]?, ExchangeRateModel?) {
        async let currencies = currencyListService.fetchCurrencies()
        async let exchangeRatesList = exchnageRateService.fetchExchangeRates()
        return try await (currencies, exchangeRatesList)
    }
    
    /// Method will process the data based on currencies and rates
    /// - Parameters:
    ///   - currencies: currencies list
    ///   - rates: rates model
    private func processFetchedData(currencies: [String: String]?, rates: ExchangeRateModel?) {
        currenciesList = currencies
        exchangeRates = rates?.rates
        countriesList = currencies?.sorted(by: { $0.value < $1.value }).compactMap { $0.key }
        filteredCountriesList = countriesList
        calculateExchangeRates(for: amount)
        initiateApiTimer()
    }
    
    /// handling the error
    /// - Parameter error: Error thrown from the upstream
    private func handleFetchError(_ error: Error) {
        showError = true
        errorMessage = error.localizedDescription
    }
    
    /// setup the publisher for Amount entered in the text field and based on that amount and selected currency code exchange rates will be calucluated.
    private func setupPublisher() {
        $amount
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] value in
                self?.calculateExchangeRates(for: value)
            }
            .store(in: &anyCancellables)
        
        $searchText
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] value in
                self?.filterCountries(with: value)
            }
            .store(in: &anyCancellables)
        
        // 1,2,3,4,5,6,7
        // 1,2,3,4,5,6,7
    }
    
    /// filtering the countries list based on the entered search
    /// - Parameter text: entered search in text field.
    private func filterCountries(with text: String) {
        if text.isEmpty {
            self.filteredCountriesList =  self.countriesList
        } else {
            self.filteredCountriesList = self.currenciesList?
                .filter({$0.value.localizedCaseInsensitiveContains(text)})
                .sorted(by: { $0.value < $1.value })
                .compactMap { $0.key }
        }
    }
    
    /// Calculation of exchange rates based on the amount
    /// - Parameter amount: Amount entered by the user
    func calculateExchangeRates(for amount: String) {
        guard let exchangeRates, let enteredAmount = Double(amount) else {
            convertedRates = [:]
            return
        }
        // if the exchange rate for selected country not availale then selected rate is set to 1.0
        let selectedRate = exchangeRates[selectedCountry] ?? 1.0
        convertedRates = exchangeRates.mapValues { rate in
            ((enteredAmount / selectedRate) * rate).roundedValue()
        }
    }
    
    /// Converts the ID into exchanged model which will contain country name, converted/exchanged amount, exchnage rate based on the USD
    /// - Parameter id: currency ID
    /// - Returns: Exchnaged model
    func getConvertedModel(for id: String) -> ExchangedModel? {
        guard let countryName = currenciesList?[id],
              let amount = convertedRates[id],
              let exchangeRate = exchangeRates?[id]?.roundedValue() else { return nil }

        return ExchangedModel(
            countryName: countryName,
            amount: amount,
            countryId: "Currency: \(id)",
            exchangeRate: "Exchange rate with USD: \(exchangeRate)"
        )
    }
    
    
    /// initiating the API timer based on the next fetch interval duration
    func initiateApiTimer() {
        timerCancellable?.cancel()
        timerCancellable =  Timer.publish(every: self.interval,
                                          on: .main,
                                          in: .common)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                Task {
                    await self?.fetchData()
                }
            }
    }
    
    
    
    //MARK: - Localised variables
    /// Last updated time stamp
    var lastUpdatedTimeStamp: String {
        APITimerService().lastAPITimeString.map { "Last updated on \($0)" } ?? ""
    }

    var navigationBarTitle: String { "Exchange Rates" }
    var textFieldPlaceHolder: String { "Enter amount here" }
    var countrySelectionTitle: String { "Select the country" }
    var errorTitle: String { "Error fetching the data" }
    var fetchTitle: String { "Fetching Exchanges Rates" }
    var retryTitle: String { "Retry" }
    var splashScreenTitle: String { "Open Exchange Rates" }
}
