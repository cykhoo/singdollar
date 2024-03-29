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

    describe "interface" do

      it "attributes and methods" do
        expect(exchange_rates).to respond_to(:date_time)
        expect(exchange_rates).to respond_to(:to_xml)
        expect(exchange_rates).to respond_to(:to_fmpxml)
      end

      describe "to_xml method" do

        let(:exchange_rates) do
          exchange_rates       = FactoryBot.build(:exchange_rates)
          exchange_rates[:usd] = FactoryBot.build(:usd_exchange_rate)
          exchange_rates[:eur] = FactoryBot.build(:eur_exchange_rate)
          exchange_rates
        end

        let(:exchange_rates_xml) { exchange_rates.to_xml}

        describe "XML declaration" do

          it "has an XML declaration" do
            expect(exchange_rates_xml).to include('<?xml')
          end

          it "has the right XML version" do
            expect(exchange_rates_xml).to include('version="1.0"')
          end

          it "has the right encoding" do
            expect(exchange_rates_xml).to include('UTF-8')
          end
        end

        describe "singdollar tag" do

          it "has a singdollar tag" do
            expect(exchange_rates_xml).to include("<singdollar")
          end

          it "has the right singdollar xmlns attribute" do
            expect(exchange_rates_xml).to include('xmlns="http://www.cantab-ip.com/singdollar')
          end

          it "has the right singdollar xmlns:xsi attribute" do
            expect(exchange_rates_xml).to include('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance')
          end

          it "has the right singdollar xsi:schema-location attribute" do
            expect(exchange_rates_xml).to include('xsi:schemaLocation="http://www.cantab-ip.com/singdollar singdollar.xsd"')
          end
        end
      end

      describe "to_fmpxml method" do

        let(:exchange_rates) do
          exchange_rates       = FactoryBot.build(:exchange_rates)
          exchange_rates[:usd] = FactoryBot.build(:usd_exchange_rate)
          exchange_rates[:eur] = FactoryBot.build(:eur_exchange_rate)
          exchange_rates
        end

        let(:exchange_rates_fmpxml) { exchange_rates.to_fmpxml}

        describe "XML declaration" do

          it "has an XML declaration" do
            expect(exchange_rates_fmpxml).to include('<?xml')
          end

          it "has the right XML version" do
            expect(exchange_rates_fmpxml).to include('version="1.0"')
          end

          it "has the right encoding" do
            expect(exchange_rates_fmpxml).to include('UTF-8')
          end
        end
      end
    end
  end
end
