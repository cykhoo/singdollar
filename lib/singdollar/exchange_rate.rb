module SingDollar

  class ExchangeRate

    attr_accessor :currency, :bank_buying, :bank_selling

    def initialize(args = {})
      @currency     = args[:currency]
      @bank_buying  = args[:bank_buying]
      @bank_selling = args[:bank_selling]
    end
  end
end
