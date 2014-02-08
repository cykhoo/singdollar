module SingDollar

  class Transaction

    attr_accessor :type, :tt, :od

    def initialize(args = {})
      @type = args[:type]
      @tt   = args[:tt]
      @od   = args[:od]
    end
  end
end
