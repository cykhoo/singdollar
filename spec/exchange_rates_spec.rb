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
      expect(exchange_rates[:usd].class).to eq(ExchangeRate)
    end
  end
end
