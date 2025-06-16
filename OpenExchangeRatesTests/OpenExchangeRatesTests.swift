//
//  OpenExchangeRatesTests.swift
//  OpenExchangeRatesTests
//
//  Created by Rajani Bhimanadam on 19/10/24.
//

import XCTest
@testable import OpenExchangeRates
import Combine

final class OpenExchangeRatesTests: XCTestCase {
    
    var viewModel: ExchangeRatesViewModel!
    var mockCurrencyService: MockCurrencyService!
    var mockExchangeRateService: MockExchangeRateService!
    var cancellables: Set<AnyCancellable>!
    
    @MainActor override func setUp() {
        super.setUp()
        cancellables = []
        mockCurrencyService = MockCurrencyService()
        mockExchangeRateService = MockExchangeRateService()
        viewModel = ExchangeRatesViewModel()
        viewModel.currencyListService = mockCurrencyService
        viewModel.exchnageRateService = mockExchangeRateService
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockCurrencyService = nil
        mockExchangeRateService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitialValues() async {
        await Task { @MainActor in
            XCTAssertEqual(viewModel.amount, "1")
            XCTAssertEqual(viewModel.selectedCountry, "USD")
            XCTAssertNil(viewModel.countriesList)
            XCTAssertTrue(viewModel.convertedRates.isEmpty)
        }.value
    }
    
    
    func testFetchDataSuccess() async throws {
        mockCurrencyService.mockCurrencies = ["USD": "United States Dollar", "EUR": "Euro"]
        mockExchangeRateService.mockRates = ["USD": 1.0, "EUR": 0.85]
        
        await viewModel.fetchData()
        
        await Task { @MainActor in
            XCTAssertEqual(viewModel.countriesList?.count, 2)
        }.value
    }
    
    func testFetchDataFailure() async {
        mockCurrencyService.shouldReturnError = true
        await viewModel.fetchData()
        await Task { @MainActor in
            XCTAssertTrue(viewModel.showError)
            XCTAssertFalse(viewModel.errorMessage.isEmpty)
        }.value
    }
    
    func testCalculateExchangeRates_ValidSelection() async {
        await Task { @MainActor in
            viewModel.exchangeRates = ["USD": 1.0, "EUR": 0.85]
            viewModel.selectedCountry = "USD"
            viewModel.amount = "100"
            viewModel.calculateExchangeRates(for: "100")
            XCTAssertEqual(viewModel.convertedRates["EUR"], "85.00")
        }.value
    }
    
    func testCalculateExchangeRates_InvalidSelection() async {
        await Task { @MainActor in
            viewModel.exchangeRates = ["USD": 1.0, "EUR": 0.85]
            viewModel.selectedCountry = "JPY" // Non-existent in mock data
            viewModel.amount = "100"
            viewModel.calculateExchangeRates(for: "100")
            XCTAssertEqual(viewModel.convertedRates["EUR"], "85.00")
        }.value
    }
    
    func testAmountPublisherDebounce() async {
        let expectation = XCTestExpectation(description: "Debounced amount change")
        await Task { @MainActor in
            viewModel.$convertedRates
                .dropFirst() // Ignore initial state
                .sink { _ in
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            viewModel.amount = "10"
            viewModel.amount = "20"
            viewModel.amount = "30"
            
            await fulfillment(of: [expectation], timeout: 3.0)
            XCTAssertEqual(viewModel.amount, "30")
        }.value
    }
    
    func testGetConvertedModel_ValidID() async {
        await Task { @MainActor in
            viewModel.currenciesList = ["USD": "United States Dollar", "EUR": "Euro"]
            viewModel.convertedRates = ["USD": "100.0", "EUR": "85.0"]
            viewModel.exchangeRates = ["USD": 1.0, "EUR": 0.85]
            
            let model = viewModel.getConvertedModel(for: "EUR")
            
            XCTAssertNotNil(model)
            XCTAssertEqual(model?.countryName, "Euro")
            XCTAssertEqual(model?.amount, "85.0")
            XCTAssertEqual(model?.exchangeRate, "Exchange rate with USD: 0.85")
        }.value
    }
    
    func testGetConvertedModel_InvalidID() async {
        await Task { @MainActor in
            viewModel.currenciesList = ["USD": "United States Dollar"]
            viewModel.convertedRates = ["USD": "100.0"]
            let model = viewModel.getConvertedModel(for: "EUR")
            XCTAssertNil(model)
        }.value
    }
    
    func testInitiateApiTimer() async {
        await Task { @MainActor in
            let expectation = XCTestExpectation(description: "API Timer triggered")
            
            viewModel.$countriesList
                .dropFirst() // Ignore initial state
                .sink { _ in
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            viewModel.initiateApiTimer()
            await fulfillment(of: [expectation], timeout: 2.0)
        }.value
    }
    
    func testLastUpdatedTimeStamp() async {
        let currentDate = Date()
        let timerService = APITimerService()
        timerService.storeLastAPICallTime(date: currentDate)
        await Task { @MainActor in
            let result = viewModel.lastUpdatedTimeStamp
            let currentDateString = currentDate.getString()
            XCTAssertEqual(result, "Last updated on \(currentDateString)")
        }.value
    }
    
    func testLocalisedString() {
        
        Task { @MainActor in
            let navigationBarTitle = "Exchange Rates"
            let textFieldPlaceHolder = "Enter amount here"
            let countrySelectionTitle = "Select the country"
            let errorTitle = "Error fetching the data"
            let fetchTitle = "Fetching Exchanges Rates"
            let retryTitle = "Retry"
            let splashScreenTitle = "Open Exchange Rates"
            if viewModel == nil {
                viewModel = ExchangeRatesViewModel()
            }
            XCTAssertTrue(viewModel.navigationBarTitle == navigationBarTitle)
            XCTAssertTrue(viewModel.textFieldPlaceHolder == textFieldPlaceHolder)
            XCTAssertTrue(viewModel.countrySelectionTitle == countrySelectionTitle)
            XCTAssertTrue(viewModel.errorTitle == errorTitle)
            XCTAssertTrue(viewModel.fetchTitle == fetchTitle)
            XCTAssertTrue(viewModel.retryTitle == retryTitle)
            XCTAssertTrue(viewModel.splashScreenTitle == splashScreenTitle)
            XCTAssertNotNil(viewModel.lastUpdatedTimeStamp)
        }
    }
    
    func testURLConfigs() {
        let configs = URLConfigurations.shared
        let url = configs.url(for: .currency, queryItems: [:])
        XCTAssertNotNil(url)
    }
    
    func testURLConfigsWithQueryItems() {
        let configs = URLConfigurations.shared

        let url = configs.url(for: .currency, queryItems: ["app_id": "id"])
        XCTAssertNotNil(url)
    }
    
    func testSearchFunctionality() async {
        Task { @MainActor in
            if viewModel == nil {
                viewModel = ExchangeRatesViewModel()
                cancellables = []
            }
            viewModel.countriesList = ["USD", "EUR", "INR", "JPY"]
            viewModel.currenciesList = [
                "USD": "United States Dollar",
                "EUR": "Euro",
                "INR": "Indian Rupee",
                "JPY": "Japanese Yen"
            ]
            
            let expectation = XCTestExpectation(description: "filterCountries should be called")
            
            // Observe filteredCountriesList to confirm filterCountries was invoked
            viewModel.$filteredCountriesList
                .sink { filteredList in
                    if filteredList == ["USD"] {
                        expectation.fulfill()
                    }
                }
                .store(in: &cancellables)
            
            // Set searchText to match "USD"
            viewModel.searchText = "Dollar"
            await fulfillment(of: [expectation], timeout: 2.0)
        }
    }
    
    func testFilterCountriesWithNonMatchingText() async {
        await Task { @MainActor in
            viewModel.countriesList = ["USD", "EUR", "INR", "JPY"]
            viewModel.currenciesList = [
                "USD": "United States Dollar",
                "EUR": "Euro",
                "INR": "Indian Rupee",
                "JPY": "Japanese Yen"
            ]
            viewModel.searchText = "Pound"
            XCTAssertNil(viewModel.filteredCountriesList)
        }.value
    }
    
    func testSplashScreenHidesAfterDelay() async {
        try? await Task { @MainActor in
            XCTAssertTrue(viewModel.showSplashScreen)
            try await Task.sleep(nanoseconds: 1_500_000_000)  // 1.5 seconds
            XCTAssertFalse(viewModel.showSplashScreen)
        }.value
    }
}


