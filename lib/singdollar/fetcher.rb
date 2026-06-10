module SingDollar

  class Fetcher
    require 'open-uri'

    EXCHANGE_RATES_JSON_URL = 'https://www.ocbc.com/FXRates/bootstrap.json'

    def fetch_exchange_rates_json
      puts "Fetching exchange rates JSON..."
      URI.open(EXCHANGE_RATES_JSON_URL).read
    end
  end
end
