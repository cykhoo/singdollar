require 'spec_helper'

module SingDollar

  describe SingDollar, :vcr, :core do

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

    let(:sing_dollar) { SingDollar }

    it "exists" do
      expect(sing_dollar).to_not be_nil
    end

    describe "methods" do

      it "has an exchange_rates method" do
        expect(sing_dollar).to respond_to(:exchange_rates)
      end

      describe "get_exchange_rates method" do

        it "returns an ExchangeRates object" do
          expect(sing_dollar.exchange_rates.class).to eq(ExchangeRates)
        end
      end
    end
  end
end
