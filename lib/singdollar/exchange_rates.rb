module SingDollar

  class ExchangeRates < Hash

    attr_accessor :date_time

    def initialize
      super
    end

    def to_xml
      XMLMaker.new(self).make_xml
    end
  end
end
