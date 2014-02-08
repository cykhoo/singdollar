require 'spec_helper'

module SingDollar

  describe ExchangeRate, :vcr, :core do

    let(:exchange_rate) { ExchangeRate.new }

    it "exists" do
      expect(exchange_rate).to_not be_nil
    end

    it "is a subclass of Hash" do
      expect(exchange_rate.class.superclass).to eq(Hash)
    end

    describe "attributes" do

      it "has attributes" do
        expect(exchange_rate).to respond_to(:bank_buying)
        expect(exchange_rate).to respond_to(:bank_selling)
      end
    end

    describe "initialize" do
      transaction_buying = FactoryGirl.build(:usd_buying)
      trasaction_selling = FactoryGirl.build(:usd_selling)
      exchange_rate = ExchangeRate.new(bank_buying: transaction_buying, bank_selling: trasaction_selling)

      it "sets the bank_buying tt key" do
        expect(exchange_rate.bank_buying.tt).to eq(1.2592)
      end

      it "sets the bank_buying od key" do
        expect(exchange_rate.bank_buying.od).to eq(1.2542)
      end

      it "sets the bank_selling tt key" do
        expect(exchange_rate.bank_selling.tt).to eq(1.2787)
      end

      it "sets the bank_selling od key" do
        expect(exchange_rate.bank_selling.od).to eq(1.2788)
      end
    end
  end
end
