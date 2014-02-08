require 'spec_helper'

module SingDollar

  describe ExchangeRate, :vcr, :core do

    let(:transaction1) { FactoryGirl.build(:usd_buying) }
    let(:transaction2) { FactoryGirl.build(:usd_selling) }

    let(:exchange_rate) do
      FactoryGirl.build(:exchange_rate, transactions: [transaction1, transaction2])
    end

    it "exists" do
      expect(exchange_rate).to_not be_nil
    end

    describe "attributes" do

      it "has attributes" do
        expect(exchange_rate).to respond_to(:currency)
        expect(exchange_rate).to respond_to(:transactions)
      end

      it "has methods" do
        expect(exchange_rate).to respond_to(:bank_buying_tt)
        expect(exchange_rate).to respond_to(:bank_buying_od)
        expect(exchange_rate).to respond_to(:bank_selling_tt)
        expect(exchange_rate).to respond_to(:bank_selling_od)
      end

      describe "currency attribute" do

        it "can be set" do
          exchange_rate = ExchangeRate.new(currency: :usd)
          expect(exchange_rate.currency).to eq(:usd)
        end
      end

      describe "transactions attribute" do

        it "can be set" do
          expect(exchange_rate.transactions[0]).to eq(transaction1)
          expect(exchange_rate.transactions[1]).to eq(transaction2)
        end
      end

      describe "bank_buying_tt method" do

        it "returns the right data" do
          expect(exchange_rate.bank_buying_tt).to eq(1.2592)
        end
      end

      describe "bank_buying_od method" do

        it "returns the right data" do
          expect(exchange_rate.bank_buying_od).to eq(1.2542)
        end
      end

      describe "bank_selling_od method" do

        it "returns the right data" do
          expect(exchange_rate.bank_selling_od).to eq(1.2787)
        end
      end

      describe "bank_selling_od method" do

        it "returns the right data" do
          expect(exchange_rate.bank_selling_od).to eq(1.2787)
        end
      end
    end
  end
end
