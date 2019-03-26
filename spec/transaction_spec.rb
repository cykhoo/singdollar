require 'spec_helper'

module SingDollar

  describe Transaction, :vcr, :core do

    let(:transaction) { Transaction.new }

    it "exists" do
      expect(transaction).to_not be_nil
    end

    describe "attributes" do

      it "has attributes" do
        expect(transaction).to respond_to(:currency)
        expect(transaction).to respond_to(:type)
        expect(transaction).to respond_to(:tt)
        expect(transaction).to respond_to(:od)
      end

      describe "setting attribute" do

        let(:transaction) { FactoryBot.build(:transaction) }

        it "currency attribute" do
          expect(transaction.currency).to eq(:usd)
        end

        it "type attribute" do
          expect(transaction.type).to eq(:bank_buying)
        end

        it "tt attribute" do
          expect(transaction.tt).to eq(1.2592)
        end

        it "od attribute" do
          expect(transaction.od).to eq(1.2542)
        end
      end
    end
  end
end
