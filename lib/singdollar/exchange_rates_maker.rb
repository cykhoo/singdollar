module SingDollar

  require 'nokogiri'
  require 'bigdecimal'

  class ExchangeRatesMaker
    attr_reader :page

    def make_exchange_rates
      @page = Fetcher.new.fetch_exchange_rates_page

      date_time = DateTimeParser.new(page).parse_date_time

      exchange_rates = CurrenciesParser.new(page).currencies_to_exchange_rates

      exchange_rates.date_time = date_time

      exchange_rates
    end
  end
end
