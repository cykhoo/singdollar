module SingDollar

  class ExchangeRates < Hash

    def initialize
      super
    end

    def to_xml
      XMLMaker.new(self).make_xml
    end
  end
end
