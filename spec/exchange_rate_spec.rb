require 'spec_helper'

module SingDollar

  describe ExchangeRate, :vcr, :core do

    let(:exchange_rate) { ExchangeRate.new }

    it "exists" do
      expect(exchange_rate).to_not be_nil
    end

    describe "attributes" do

      it "has attributes" do
        expect(exchange_rate).to respond_to(:currency)
        expect(exchange_rate).to respond_to(:transaction)
      end

      describe "currency attribute" do

        it "can be set" do
          exchange_rate = ExchangeRate.new(currency: :usd)
          expect(exchange_rate.currency).to eq(:usd)
        end
      end

      describe "transaction attribute" do

        it "can be set" do
          exchange_rate = ExchangeRate.new(transaction: :bank_buying)
          expect(exchange_rate.transaction).to eq(:bank_buying)
        end
      end
    end
  end
end
