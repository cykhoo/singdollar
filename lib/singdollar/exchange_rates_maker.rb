module SingDollar

  require 'mechanize'
  require 'nokogiri'
  require 'bigdecimal'

  class ExchangeRatesMaker

    def create
      exchange_rates = ExchangeRates.new
      exchange_rates.date_time = make_date_time
      currencies = %w(:usd :aud :cad :cnh :dkk :eur :hkd :inr :idr :jpy :nzd :nok :lkr :gbp :sek :chf :thb)
      currencies.each_with_index do |currency, index|
        currency_node = currency_node(index)
        exchange_rate = make_exchange_rate(currency_node)
        exchange_rates[exchange_rate.currency] = exchange_rate
      end
      exchange_rates
    end

    def make_exchange_rate(currency_node)

        exchange_rate = ExchangeRate.new

        units = currency_node[1].text.strip.split[0].to_f

        currency = currency_node[0].text.strip.downcase.to_sym

        transaction_bank_selling = Transaction.new

        transaction_bank_selling.currency = currency
        transaction_bank_selling.type     = :bank_selling
        bank_selling_tt_od                = (BigDecimal.new(currency_node[3].text.strip)/units).to_f
        transaction_bank_selling.tt       = bank_selling_tt_od
        transaction_bank_selling.od       = bank_selling_tt_od

        transaction_bank_buying = Transaction.new

        transaction_bank_buying.currency = currency
        transaction_bank_buying.type     = :bank_buying
        transaction_bank_buying.tt       = (BigDecimal.new(currency_node[4].text.strip)/units).to_f
        transaction_bank_buying.od       = (BigDecimal.new(currency_node[5].text.strip)/units).to_f

        exchange_rate.bank_selling = transaction_bank_selling
        exchange_rate.bank_buying  = transaction_bank_buying

        exchange_rate.currency = transaction_bank_selling.currency

        exchange_rate
    end

    def agent
      @agent ||= Mechanize.new
    end

    def page
      @page ||= agent.get('http://www.ocbc.com/rates/daily_price_fx.html')
    end

    def html
      @html ||= page.body
    end

    def doc
      @doc ||= Nokogiri::HTML(html)
    end

    def currency_node(index)
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[#{index + 3}]/td")
    end

    def rates_table
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[4]/td")
    end

    def date_time_node
      doc.xpath("//*[text()='OCBC FOREIGN EXCHANGE RATES']/following-sibling::p[2]")
    end

    def make_date_time
      date_time_text = date_time_node.text
      date_match = date_time_text.match(/\d{2}\s[a-zA-Z]{3}\s\d{4}/)[0]
      time_match = date_time_text.match(/\d{2}:\d{2}:\d{2}\s(AM|PM)/)[0]
      Time.parse(date_match + " " + time_match)
    end
  end
end
