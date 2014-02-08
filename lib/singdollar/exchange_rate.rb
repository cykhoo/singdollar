module SingDollar

  class ExchangeRate

    attr_accessor :currency, :transaction

    def initialize(args = {})
      @currency    = args[:currency]
      @transaction = args[:transaction]
    end
  end
end
