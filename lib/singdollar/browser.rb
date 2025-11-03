module SingDollar

  class Browser

    attr_reader :session

    require 'capybara'
    require 'selenium/webdriver'

    SELENIUM_URL = ENV["SELENIUM_REMOTE_URL"]

    def self.chrome_options(headless: false)
      opts = Selenium::WebDriver::Chrome::Options.new
      opts.add_option("excludeSwitches", ["enable-automation"])
      opts.add_argument("--no-sandbox")
      opts.add_argument("--disable-dev-shm-usage")
      opts.add_argument("--window-size=1280,800")
      opts.add_argument("--disable-gpu")
      opts.add_argument("--headless=new") if headless
      opts
    end

    Capybara.register_driver :chrome do |app|
      options = chrome_options(headless: false)
      if SELENIUM_URL && !SELENIUM_URL.empty?
        Capybara::Selenium::Driver.new(
          app,
          browser: :remote,
          url: SELENIUM_URL,
          capabilities: options
        )
      else
        Capybara::Selenium::Driver.new(
          app,
          browser: :chrome,
          options: options
        )
      end
    end

    Capybara.register_driver :headless_chrome do |app|
      options = chrome_options(headless: true)
      if SELENIUM_URL && !SELENIUM_URL.empty?
        Capybara::Selenium::Driver.new(
          app,
          browser: :remote,
          url: SELENIUM_URL,
          capabilities: options
        )
      else
        Capybara::Selenium::Driver.new(
          app,
          browser: :chrome,
          options: options
        )
      end
    end

    Capybara.default_driver    = :chrome
    Capybara.javascript_driver = :chrome

    Capybara.default_max_wait_time = 100

    def initialize
      @session = Capybara::Session.new(:chrome)
    end
  end

  class HeadlessBrowser < Browser

    def initialize
      @session = Capybara::Session.new(:headless_chrome)
    end
  end
end
