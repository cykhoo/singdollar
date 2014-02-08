require 'spec_helper'

module SingDollar

  describe ExchangeRate, :vcr, :core do

    let(:exchange_rate) { ExchangeRate.new }

    it "exists" do
      expect(exchange_rate).to_not be_nil
    end
  end
end
