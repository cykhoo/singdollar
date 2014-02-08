module SingDollar

  class ExchangeRate

    attr_accessor :currency, :transactions

    def initialize(args = {})
      @currency     = args[:currency]
      @transactions = args[:transactions]
    end
  end
end
