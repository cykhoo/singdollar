require 'spec_helper'

module SingDollar

  describe Client, :core, :vcr do

    let(:client) { Client.new }

    it "exists" do
      expect(client).to_not be_nil
    end

    it "has the right methods" do
      expect(client).to respond_to(:get_url)
      expect(client).to respond_to(:post_url)
    end

    describe "get_url method" do
      it "fetches a URL by GET" do
        site = Client.new.get_url('http://www.cantab-ip.com', 'UTF-8')
        expect(site).to include('<html')
      end
    end

    describe "post_url method" do
      it "fetches a URL by POST" do
        site = Client.new.post_url('http://www.google.com', {})
        expect(site).to include('<html')
      end
    end
  end
end
