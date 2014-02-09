module SingDollar

  require 'singdollar/version'
  require 'singdollar/exchange_rates'
  require 'singdollar/exchange_rate'
  require 'singdollar/transaction'
  require 'singdollar/exchange_rates_maker'

  class << self

    def get_exchange_rates
      ExchangeRates.new
    end
  end
end
