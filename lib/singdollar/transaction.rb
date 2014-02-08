module SingDollar

  class Transaction

    attr_accessor :currency, :type, :tt, :od

    def initialize(args = {})
      @currency = args[:currency]
      @type = args[:type]
      @tt   = args[:tt]
      @od   = args[:od]
    end
  end
end
