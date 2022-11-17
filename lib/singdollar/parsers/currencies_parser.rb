module SingDollar

  class CurrenciesParser

    attr_reader :page

    def initialize(page)
      @page = page
    end

    def currencies_to_exchange_rates
      puts "Getting available currencies..."
      currencies_column = get_currencies_column
      currencies = get_available_currencies(currencies_column)

      exchange_rates = ExchangeRates.new

      currencies.each_with_index do |currency, index|
        currency_node = get_currency_node(index)
        exchange_rate = make_exchange_rate(currency, currency_node)
        exchange_rates[exchange_rate.currency] = exchange_rate
      end

      exchange_rates
    end

    private

    def get_currencies_column
      puts "Searching for currencies in page..."
      page.xpath("//th[text()='Currency']/../../following-sibling::tbody/tr/td[1]/text()")
    end

    def get_available_currencies(currencies_column)
      puts "Getting available currencies..."
      currencies = currencies_column.map do |currency_cell|
        currency_cell.text[0..2].downcase.to_sym
      end
      currencies
    end

    def get_currency_node(index)
      page.xpath("//th[text()='Currency']/../../following-sibling::tbody/tr[#{index + 1}]/td[position() >= 2 and position() <=4 ]/text()")
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
  end
end
