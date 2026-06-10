require 'spec_helper'

module SingDollar

  describe ExchangeRatesMaker, :core do

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

    let(:json) do
      JSON.generate(
        'fxRatesSgd' => currency_rows.map do |code, name, unit, sell_rate, buy_rate|
          {
            'baseCurrencyCode' => code,
            'baseCurrencyName' => name,
            'exchangeCurrencyCode' => 'SGD',
            'exchangeCurrencyName' => 'Singapore Dollar',
            'unitForSGDExchange' => unit,
            'tieredExchangeRates' => [
              {
                'tierLevel' => 1,
                'bankSellRate' => sell_rate,
                'bankBuyRate' => buy_rate
              }
            ]
          }
        end,
        'lastUpdated' => '2026-06-10T07:00:12'
      )
    end

    let(:currency_rows) do
      [
        ['USD', 'American Dollar', 1, 1.298, 1.2766],
        ['AUD', 'Australian Dollar', 1, 0.9192, 0.8901],
        ['CAD', 'Canadian Dollar', 1, 0.9342, 0.9138],
        ['CNH', 'Chinese Yuan Offshore', 1, 0.1813, 0.1748],
        ['DKK', 'Danish Krone', 100, 20.31, 19.52],
        ['EUR', 'Euro', 1, 1.5155, 1.4729],
        ['HKD', 'Hong Kong Dollar', 100, 16.69, 16.19],
        ['INR', 'Indian Rupee', 100, 1.381, 0.0],
        ['IDR', 'Indonesian Rupiah', 100, 0.0074, 0.0],
        ['JPY', 'Japanese Yen', 100, 0.8121, nil],
        ['NZD', 'New Zealand Dollar', 1, 0.7639, 0.738],
        ['NOK', 'Norwegian Krone', 100, 13.17, 12.57],
        ['LKR', 'Sri Lankan Rupee', 100, 0.435, 0.0],
        ['GBP', 'Sterling Pound', 1, 1.7433, 1.7004],
        ['SEK', 'Swedish Krona', 100, 13.98, 13.38],
        ['CHF', 'Swiss Franc', 1, 1.6293, 1.5817],
        ['THB', 'Thai Baht', 100, 4.062, 3.892]
      ]
    end

    describe "interface" do

      it "attributes and methods" do
        expect(exchange_rates_maker).to respond_to(:create)
        expect(exchange_rates_maker).to respond_to(:create_from_json)
      end
    end

    describe "create_from_json method" do

      let(:exchange_rates) { exchange_rates_maker.create_from_json(json) }

      it "returns an ExchangeRates object" do
        expect(exchange_rates.class).to eq(ExchangeRates)
      end

      it "sets the date_time component" do
        expect(exchange_rates.date_time.strftime('%Y-%m-%d %H:%M:%S')).to eq('2026-06-10 07:00:12')
      end

      it "creates currency components" do
        expect(exchange_rates[:usd].currency).to eq(:usd)
        expect(exchange_rates[:jpy].currency).to eq(:jpy)
      end

      it "maps tier 1 bank buying and selling rates" do
        expect(exchange_rates[:usd].bank_selling.rate).to eq(1.298)
        expect(exchange_rates[:usd].bank_buying.rate).to eq(1.2766)
      end

      it "normalizes rates by currency unit" do
        expect(exchange_rates[:jpy].bank_selling.rate).to eq(0.008121)
      end

      it "maps unavailable rates to zero" do
        expect(exchange_rates[:jpy].bank_buying.rate).to eq(0)
      end
    end

    describe "create method" do

      before do
        fetcher = instance_double(Fetcher, fetch_exchange_rates_json: json)
        allow(Fetcher).to receive(:new).and_return(fetcher)
      end

      let(:exchange_rates) { exchange_rates_maker.create }

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
