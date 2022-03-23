require 'spec_helper'

module SingDollar

  describe ExchangeRatesMaker, :vcr, :core do

    before(:all) do
      @original_stdout = $stdout
      @original_stderr = $stderr
      $stdout = File.open(File::NULL, 'w')
      $stderr = File.open(File::NULL, 'w')
    end

    after(:all) do
      $stdout = @original_stdout
      $stderr = @original_stderr
      @original_stdout = nil
      @original_stderr = nil
    end

    let(:exchange_rates_maker) { ExchangeRatesMaker.new }

    describe "interface" do

      it "attributes and methods" do
        expect(exchange_rates_maker).to respond_to(:session)
        expect(exchange_rates_maker).to respond_to(:doc)
        expect(exchange_rates_maker).to respond_to(:make_exchange_rate)
        expect(exchange_rates_maker).to respond_to(:make_exchange_rates)
        expect(exchange_rates_maker).to respond_to(:make_exchange_rate)
        expect(exchange_rates_maker).to respond_to(:visit_exchange_rates_page)
        expect(exchange_rates_maker).to respond_to(:parse_html_with_nokogiri)
        expect(exchange_rates_maker).to respond_to(:currencies_column)
        expect(exchange_rates_maker).to respond_to(:currency_node)
        expect(exchange_rates_maker).to respond_to(:date_node)
        expect(exchange_rates_maker).to respond_to(:time_node)
        expect(exchange_rates_maker).to respond_to(:get_available_currencies)
        expect(exchange_rates_maker).to respond_to(:make_date_time)
      end
    end

    describe "make_exchange_rates method" do

      let(:exchange_rates) { exchange_rates_maker.make_exchange_rates }

      it "returns an ExchangesRates object" do
        expect(exchange_rates.class).to eq(ExchangeRates)
      end

      describe "ExchangeRates components" do

        it "has a date_time component" do
          expect(exchange_rates.date_time).to_not be_nil
        end

        it "has :usd component" do
          expect(exchange_rates[:usd]).to_not be_nil
        end

        describe ":usd component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:usd]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:usd].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:usd]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:usd].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":aud component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:aud]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:aud].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:aud]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:aud].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":cad component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:cad]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:cad].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:cad]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:cad].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":cnh component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:cnh]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:cnh].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:cnh]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:cnh].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":dkk component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:dkk]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:dkk].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:dkk]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:dkk].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":eur component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:eur]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:eur].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:eur]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:eur].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":hkd component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:hkd]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:hkd].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:hkd]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:hkd].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":inr component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:inr]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:inr].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:inr]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:inr].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":idr component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:idr]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:idr].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:idr]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:idr].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":jpy component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:jpy]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:jpy].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:jpy]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:jpy].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":nzd component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:nzd]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:nzd].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:nzd]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:nzd].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":nok component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:nok]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:nok].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:nok]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:nok].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":lkr component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:lkr]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:lkr].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:lkr]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:lkr].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":gbp component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:gbp]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:gbp].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:gbp]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:gbp].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":sek component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:sek]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:sek].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:sek]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:sek].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":chf component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:chf]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:chf].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:chf]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:chf].bank_selling.rate).to_not be_nil
            end
          end
        end

        describe ":thb component" do

          describe "bank_buying" do

            it "has a bank_buying method" do
              expect(exchange_rates[:thb]).to respond_to(:bank_buying)
            end

            it "has a value for bank_buying.rate" do
              expect(exchange_rates[:thb].bank_buying.rate).to_not be_nil
            end
          end

          describe "bank_selling" do

            it "has a bank_selling method" do
              expect(exchange_rates[:thb]).to respond_to(:bank_selling)
            end

            it "has a value for bank_selling.rate" do
              expect(exchange_rates[:thb].bank_selling.rate).to_not be_nil
            end
          end
        end
      end
    end
  end
end
