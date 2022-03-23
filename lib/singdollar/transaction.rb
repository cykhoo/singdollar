module SingDollar

  class Transaction

    attr_accessor :currency, :type, :rate

    def initialize(args = {})
      @currency = args[:currency]
      @type     = args[:type]
      @rate     = args[:rate]
    end
  end
end
