require 'spec_helper'

module SingDollar

  describe RatesService, :vcr, :core do
    it "exists" do
      expect(RatesService).to_not be_nil
    end

    describe "constants" do
      it "has a constant for access url" do
        expect(RatesService::RATES_URL).to_not be_nil
      end
    end

    describe "methods" do
      let(:rates_service) { RatesService.new }

      it "has accessible public methods" do
        expect(rates_service).to respond_to(:rates_html)
      end

      it "has inaccessible private methods" do
      end

      describe "register_fetch method" do
        let(:rates_html) { rates_service.rates_html }

        it "returns a string" do
          expect(rates_html).to be_instance_of(String)
        end

        it "returns an HTML document" do
          expect(rates_html).to include('<html')
        end

        it "fetches an html page containing forex information" do
          expect(rates_html).to include('OCBC FOREIGN EXCHANGE RATES')
        end
      end
    end
  end
end
