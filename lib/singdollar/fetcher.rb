module SingDollar

  class Fetcher

    attr_reader :session

    EXCHANGE_RATES_URL = 'https://www.ocbc.com/rates/daily_price_fx.html'

    def initialize
      @session = HeadlessBrowser.new.session
    end

    def fetch_exchange_rates_page
      puts "Visiting exchange rates page..."
      session.visit EXCHANGE_RATES_URL
      puts "Waiting for exchange rates to load..."
      sleep 0.1 until session.has_content?('American Dollar')
      page_html = session.html
      page_html
    end
  end
end
