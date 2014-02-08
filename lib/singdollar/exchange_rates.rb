module SingDollar

  class ExchangeRates < Hash

    def initialize
      self[:eur] = ExchangeRate.new
      self[:usd] = ExchangeRate.new
      super
    end
  end
end
