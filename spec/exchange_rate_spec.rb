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
        expect(exchange_rate).to respond_to(:transactions)
      end

      describe "currency attribute" do

        it "can be set" do
          exchange_rate = ExchangeRate.new(currency: :usd)
          expect(exchange_rate.currency).to eq(:usd)
        end
      end

      describe "transaction attribute" do

        it "can be set" do
          transaction1 = FactoryGirl.build(:transaction)
          transaction2 = FactoryGirl.build(:transaction, currency: :eur, tt: 1.7125, od: 1.7065)
          exchange_rate = FactoryGirl.build(:exchange_rate, transactions: [transaction1, transaction2])
          expect(exchange_rate.transactions[0]).to eq(transaction1)
          expect(exchange_rate.transactions[1]).to eq(transaction2)
        end
      end
    end
  end
end
