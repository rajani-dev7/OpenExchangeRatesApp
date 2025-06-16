## Open Exchange Rates Application
## Features and Requirements

1. API will be called to fetch the exchange rates available at the current moment
2. Exchange rates will be calucuated based on the **base price of US value**.
3. API will be called for **every 30 minutes only** to minimise the API calls on every launch
4. Once the response is received we will be storing the same in URL Cache along with the time stamp.
5. Once the stored time stamp is reached to 30 minutes then service call will be initiated again to get the exchange rates.
6. User can be able to **select the currency from the list of currencies provided**.
7. User can be able to enter the desired amount for the selected currency and exchange rates will be displayed accordingly.
8. If exchange rate for a selected country is not available then conversion is based on the base price.
9. On conversion, floating point errors are handled and conversion type can be provide in the config file.
10. User can be able to **search for desired country** to see the exchange rate with selected currency.

## Unit test cases included for business logic.