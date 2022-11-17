module SingDollar

  require 'nokogiri'
  require 'bigdecimal'

  class ExchangeRatesMaker
    attr_reader :page

    def create
      html = Fetcher.new.fetch_exchange_rates_page
      html_to_exchange_rates(html)
    end

    def create_from_html(html)
      html_to_exchange_rates(html)
    end

    private

    def html_to_exchange_rates(html)
      @page = Nokogiri::HTML(html)
      date_time = DateTimeParser.new(page).parse_date_time
      exchange_rates = CurrenciesParser.new(page).currencies_to_exchange_rates
      exchange_rates.date_time = date_time
      exchange_rates
    end
  end
end
