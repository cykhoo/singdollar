module SingDollar

  require 'mechanize'
  require 'nokogiri'
  require 'bigdecimal'

  class ExchangeRatesMaker

    def create
      exchange_rates = ExchangeRates.new
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
      @agent || Mechanize.new
    end

    def page
      @page || agent.get('http://www.ocbc.com/rates/daily_price_fx.html')
    end

    def html
      page.body
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

    def usd_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[3]/td")
    end

    def aud_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[4]/td")
    end

    def cad_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[5]/td")
    end

    def cnh_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[6]/td")
    end

    def dkk_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[7]/td")
    end

    def eur_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[8]/td")
    end

    def hkd_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[9]/td")
    end

    def inr_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[10]/td")
    end

    def idr_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[11]/td")
    end

    def jpy_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[12]/td")
    end

    def nzd_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[13]/td")
    end

    def nok_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[14]/td")
    end

    def lkr_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[15]/td")
    end

    def gbp_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[16]/td")
    end

    def sek_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[17]/td")
    end

    def chf_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[18]/td")
    end

    def thb_row
      doc.xpath("//*[text()='Foreign Exchange against S$']/../following-sibling::table[1]//tr[19]/td")
    end
  end
end
