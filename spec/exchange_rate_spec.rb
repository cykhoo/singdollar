require 'spec_helper'

module SingDollar

  describe ExchangeRate, :vcr, :core do

    let(:exchange_rate) { FactoryBot.build(:exchange_rate) }

    it "exists" do
      expect(exchange_rate).to_not be_nil
    end

    describe "attributes" do

      it "has attributes" do
        expect(exchange_rate).to respond_to(:bank_buying)
        expect(exchange_rate).to respond_to(:bank_selling)
      end
    end

    describe "components" do

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
