module SingDollar

  class RatesService

    attr_reader :client, :rates_html

    def initialize
      @client = Client.new
    end

    RATES_URL = "http://www.ocbc.com/rates/daily_price_fx.html"

    def rates_html
      client.get_url(RATES_URL)
    end
  end
end
