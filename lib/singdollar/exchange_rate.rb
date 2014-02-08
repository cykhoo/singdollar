module SingDollar

  class ExchangeRate

    attr_accessor :currency, :transactions
    attr_reader :bank_buying_tt, :bank_buying_od, :bank_selling_tt, :bank_selling_od

    def initialize(args = {})
      @currency     = args[:currency]
      @transactions = args[:transactions]
    end

    def bank_buying_tt
      return @bank_buying_tt if @bank_buying_tt != nil
      transactions.each do |transaction|
        if transaction.type == :bank_buying
          @bank_buying_tt = transaction.tt
        end
      end
      @bank_buying_tt
    end

    def bank_buying_od
      return @bank_buying_od if @bank_buying_od != nil
      transactions.each do |transaction|
        if transaction.type == :bank_buying
          @bank_buying_od = transaction.od
        end
      end
      @bank_buying_od
    end

    def bank_selling_tt
      return @bank_selling_tt if @bank_selling_tt != nil
      transactions.each do |transaction|
        if transaction.type == :bank_selling
          @bank_selling_tt = transaction.tt
        end
      end
      @bank_selling_tt
    end

    def bank_selling_od
      return @bank_selling_od if @bank_selling_od != nil
      transactions.each do |transaction|
        if transaction.type == :bank_selling
          @bank_selling_od = transaction.od
        end
      end
      @bank_selling_od
    end
  end
end
