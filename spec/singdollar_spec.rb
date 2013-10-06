require 'spec_helper'

module SingDollar

  describe SingDollar, :vcr, :core do

    let(:sing_dollar) { SingDollar }

    it "exists" do
      expect(sing_dollar).to_not be_nil
    end
  end
end
