module SingDollar

  require 'singdollar/version'
  require 'singdollar/browser'
  require 'singdollar/exchange_rates'
  require 'singdollar/exchange_rate'
  require 'singdollar/transaction'
  require 'singdollar/exchange_rates_maker'
  require 'singdollar/xml_maker'
  require 'singdollar/xml_filemaker_maker'

  class << self

    def exchange_rates
      ExchangeRatesMaker.new.make_exchange_rates
    end
  end
end
