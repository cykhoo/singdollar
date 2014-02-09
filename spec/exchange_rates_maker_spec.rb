require 'spec_helper'

module SingDollar

  describe ExchangeRatesMaker, :vcr, :core do

    let(:exchange_rates_maker) { ExchangeRatesMaker.new }

    describe "interface" do
      it "methods" do
        expect(exchange_rates_maker).to respond_to(:create)
      end
    end

    describe "puts" do
      it "puts" do
        exchange_rates = exchange_rates_maker.create

        puts exchange_rates.inspect
        # expect(exchange_rates_maker.create).to eq(1.2592)
      end
    end

    describe "create method" do

      let(:exchange_rates) { exchange_rates_maker.create }

      xit "returns an ExchangesRates object" do
        expect(exchange_rates.class).to eq(ExchangeRates)
      end

      describe "ExchangeRates components" do

        xit "has :eur component" do
          expect(exchange_rates[:eur]).to_not be_nil
        end

        describe ":eur component" do

          xit "has a bank_buying method" do
            expect(exchange_rates[:eur]).to respond_to(:bank_buying)
          end

          xit "has a value for bank_buying.tt" do
            expect(exchange_rates[:eur].bank_buying.tt).to eq(1.2592)
          end
        end
      end
    end
  end
end
