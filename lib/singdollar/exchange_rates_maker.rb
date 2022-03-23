module SingDollar

  require 'nokogiri'
  require 'bigdecimal'

  class ExchangeRatesMaker

    attr_reader :session, :doc

    EXCHANGE_RATES_URL = 'https://www.ocbc.com/rates/daily_price_fx.html'

    def initialize
      @session = HeadlessBrowser.new.session
    end

    def make_exchange_rates
      visit_exchange_rates_page
      parse_html_with_nokogiri
      exchange_rates = ExchangeRates.new
      exchange_rates.date_time = make_date_time
      currencies = get_available_currencies
      currencies.each_with_index do |currency, index|
        currency_node = currency_node(index)
        exchange_rate = make_exchange_rate(currency, currency_node)
        exchange_rates[exchange_rate.currency] = exchange_rate
      end
      exchange_rates
    end

    def make_exchange_rate(currency, currency_node)

        exchange_rate = ExchangeRate.new

        units = currency_node[0].text.strip.split[0].to_f

        transaction_bank_selling = Transaction.new

        transaction_bank_selling.currency = currency
        transaction_bank_selling.type     = :bank_selling

        if currency_node[1].text.strip != "N.A."
          transaction_bank_selling.rate = (BigDecimal(currency_node[1].text.strip)/units).to_f
        else
          transaction_bank_selling.rate = 0
        end

        transaction_bank_buying = Transaction.new

        transaction_bank_buying.currency = currency
        transaction_bank_buying.type     = :bank_buying

        if currency_node[2].text.strip != "N.A."
          transaction_bank_buying.rate = (BigDecimal(currency_node[2].text.strip)/units).to_f
        else
          transaction_bank_buying.rate = 0
        end

        exchange_rate.bank_selling = transaction_bank_selling
        exchange_rate.bank_buying  = transaction_bank_buying
        exchange_rate.currency     = transaction_bank_selling.currency

        exchange_rate
    end

    def visit_exchange_rates_page
      puts "Visiting exchange rates page..."
      session.visit EXCHANGE_RATES_URL
      puts "Waiting for exchange rates to load..."
      sleep 0.1 until session.has_content?('American Dollar')
      session
    end

    def parse_html_with_nokogiri
      puts "Parsing HTML of exchange rates page..."
      @doc ||= Nokogiri::HTML(session.body)
    end

    def currencies_column
      puts "Searching for currencies in page..."
      return doc.xpath("//th[text()='Currency']/../../following-sibling::tbody/tr/td[1]/text()")
    end

    def currency_node(index)
      return doc.xpath("//th[text()='Currency']/../../following-sibling::tbody/tr[#{index + 1}]/td[position() >= 2 and position() <=4 ]/text()")
    end

    def date_node
      puts "Searching for date page was updated..."
      return doc.xpath("//*[@id='ocbc-fx-calculator-last-update-date']/text()")
    end

    def time_node
      puts "Searching for time page was updated..."
      return doc.xpath("//*[@id='ocbc-fx-calculator-last-update-time']/text()")
    end

    def get_available_currencies
      puts "Getting available currencies..."
      currencies_list = currencies_column.map do |currency|
        currency.text[0..2].downcase.to_sym
      end
      currencies_list
    end

    def make_date_time
      puts "Generating timestamp..."
      date_time_text = date_node.text + " " + time_node.text
      date_time = Time.parse(date_time_text)
      date_time
    end
  end
end
