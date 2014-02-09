module SingDollar

  class ExchangeRate

    attr_accessor :bank_buying, :bank_selling

    def initialize(args = {})
      @bank_buying  = args[:bank_buying]
      @bank_selling = args[:bank_selling]
    end
  end
end
