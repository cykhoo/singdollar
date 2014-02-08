require 'spec_helper'

module SingDollar

  describe Transactions, :vcr, :core do

    let(:transactions) { Transactions.new }

    it "exists" do
      expect(transactions).to_not be_nil
    end

    it "is a subclass of Hash" do
      expect(transactions.class.superclass).to eq(Hash)
    end

    describe "attributes" do

      it "has attributes" do
        expect(transactions).to respond_to(:bank_buying)
        expect(transactions).to respond_to(:bank_selling)
      end
    end

    describe "initialize" do
      transaction_buying = FactoryGirl.build(:usd_buying)
      trasaction_selling = FactoryGirl.build(:usd_selling)
      transactions = Transactions.new(bank_buying: transaction_buying, bank_selling: trasaction_selling)

      it "sets the bank_buying tt key" do
        expect(transactions.bank_buying.tt).to eq(1.2592)
      end

      it "sets the bank_buying od key" do
        expect(transactions.bank_buying.od).to eq(1.2542)
      end

      it "sets the bank_selling tt key" do
        expect(transactions.bank_selling.tt).to eq(1.2787)
      end

      it "sets the bank_selling od key" do
        expect(transactions.bank_selling.od).to eq(1.2788)
      end
    end
  end
end
