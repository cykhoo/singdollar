module SingDollar

  require 'singdollar/version'
  require 'singdollar/exchange_rates'
  require 'singdollar/exchange_rate'
  require 'singdollar/transaction'
  require 'singdollar/exchange_rates_maker'

  class << self

    def create
      ExchangeRatesMaker.new.create
    end
  end
end
