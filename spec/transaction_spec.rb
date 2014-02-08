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

      describe "currency attribute" do

        it "can be set" do
          transaction = Transaction.new(currency: :usd)
          expect(transaction.currency).to eq(:usd)
        end
      end

      describe "type attribute" do

        it "can be set" do
          transaction = Transaction.new(type: :bank_buying)
          expect(transaction.type).to eq(:bank_buying)
        end
      end

      describe "tt attribute" do

        it "can be set" do
          transaction = Transaction.new(tt: 1.2592)
          expect(transaction.tt).to eq(1.2592)
        end
      end

      describe "od attribute" do

        it "can be set" do
          transaction = Transaction.new(od: 1.2542)
          expect(transaction.od).to eq(1.2542)
        end
      end
    end
  end
end
