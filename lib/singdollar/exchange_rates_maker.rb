module SingDollar

  require 'json'
  require 'bigdecimal'
  require 'time'

  class ExchangeRatesMaker
    def create
      json = Fetcher.new.fetch_exchange_rates_json
      json_to_exchange_rates(json)
    end

    def create_from_json(json)
      json_to_exchange_rates(json)
    end

    private

    def json_to_exchange_rates(json)
      data = JSON.parse(json)
      exchange_rates = ExchangeRates.new

      data.fetch('fxRatesSgd').each do |currency_data|
        exchange_rate = make_exchange_rate_from_json(currency_data)
        exchange_rates[exchange_rate.currency] = exchange_rate
      end

      exchange_rates.date_time = Time.parse(data.fetch('lastUpdated'))
      exchange_rates
    end

    def make_exchange_rate_from_json(currency_data)
      currency = currency_data.fetch('baseCurrencyCode').downcase.to_sym
      unit = BigDecimal(currency_data.fetch('unitForSGDExchange').to_s)
      tier = currency_data.fetch('tieredExchangeRates').find { |rate| rate['tierLevel'] == 1 }
      tier ||= currency_data.fetch('tieredExchangeRates').first

      exchange_rate = ExchangeRate.new
      exchange_rate.currency = currency
      exchange_rate.bank_selling = make_transaction_from_json(currency, :bank_selling, tier['bankSellRate'], unit)
      exchange_rate.bank_buying = make_transaction_from_json(currency, :bank_buying, tier['bankBuyRate'], unit)
      exchange_rate
    end

    def make_transaction_from_json(currency, type, rate, unit)
      Transaction.new(
        currency: currency,
        type: type,
        rate: normalized_rate(rate, unit)
      )
    end

    def normalized_rate(rate, unit)
      return 0 if rate.nil? || unit.zero?

      (BigDecimal(rate.to_s) / unit).to_f
    end
  end
end
