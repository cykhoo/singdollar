require 'spec_helper'

module SingDollar

  describe ExchangeRates, :vcr, :core do

    let(:exchange_rates) { ExchangeRates.new }

    it "exists" do
      expect(exchange_rates).to_not be_nil
    end

    it "is a subclass of Hash" do
      expect(exchange_rates.class.superclass).to eq(Hash)
    end

    it "values are ExchangeRate objects" do
      usd_exchange_rate = FactoryGirl.build(:usd_exchange_rate)
      exchange_rates    = { usd: usd_exchange_rate }
      expect(exchange_rates[:usd].class).to eq(ExchangeRate)
    end

    describe "complex ExchangeRates object" do

      let(:exchange_rates) do
        usd_exchange_rate = FactoryGirl.build(:usd_exchange_rate)
        eur_exchange_rate = FactoryGirl.build(:eur_exchange_rate)
        { usd: usd_exchange_rate, eur: eur_exchange_rate }
      end

      it "can be built" do
        expect(exchange_rates).to_not be_nil
      end
    end
  end
end
