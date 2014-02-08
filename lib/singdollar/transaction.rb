module SingDollar

  class Transaction

    attr_accessor :name, :tt, :od

    def initialize(args = {})
      @name = args[:name]
      @tt = args[:tt]
      @od = args[:od]
    end
  end
end
