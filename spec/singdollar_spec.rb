require 'spec_helper'

module SingDollar

  describe SingDollar, :vcr, :core do

    let(:sing_dollar) { SingDollar }

    it "exists" do
      expect(sing_dollar).to_not be_nil
    end

    describe "methods" do

      it "has an get_exhange_rates method" do
        expect(sing_dollar).to respond_to(:get_exchange_rates)
      end

      describe "get_exchange_rates method" do

        it "returns an ExchangeRates object" do
          expect(sing_dollar.get_exchange_rates.class).to eq(ExchangeRates)
        end
      end
    end
  end
end
