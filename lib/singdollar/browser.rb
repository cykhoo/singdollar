module SingDollar
  class Browser
    require "capybara"
    require "selenium-webdriver"

    attr_reader :session

    SELENIUM_URL = ENV.fetch("SELENIUM_REMOTE_URL", "")

    def self.chrome_options(headless: true)
      Selenium::WebDriver::Chrome::Options.new.tap do |opts|
        opts.add_argument("--no-sandbox")
        opts.add_argument("--disable-dev-shm-usage")
        opts.add_argument("--window-size=1280,800")
        opts.add_argument("--disable-gpu")
        opts.add_argument("--headless=new") if headless
      end
    end

    # Use a slower-but-robust HTTP client for Selenium session handshakes
    def self.selenium_http_client
      open_t = Integer(ENV.fetch("SELENIUM_OPEN_TIMEOUT", "120"))
      read_t = Integer(ENV.fetch("SELENIUM_READ_TIMEOUT", "300"))
      Selenium::WebDriver::Remote::Http::Default.new(
        open_timeout: open_t,
        read_timeout: read_t
      )
    end

    # default Capybara settings (env overridable)
    Capybara.configure do |c|
      c.default_driver        = :headless_chrome
      c.javascript_driver     = :headless_chrome
      c.default_max_wait_time = Integer(ENV.fetch("CAPYBARA_WAIT", "60"))
    end

    # normal chrome (can be remote or local)
    Capybara.register_driver :chrome do |app|
      options = chrome_options(headless: false)
      client  = selenium_http_client

      if !SELENIUM_URL.empty?
        Capybara::Selenium::Driver.new(
          app,
          browser: :remote,
          url: SELENIUM_URL,
          options: options,
          http_client: client
        )
      else
        Capybara::Selenium::Driver.new(
          app,
          browser: :chrome,
          options: options,
          http_client: client
        )
      end
    end

    # headless chrome (can be remote or local)
    Capybara.register_driver :headless_chrome do |app|
      options = chrome_options(headless: true)
      client  = selenium_http_client

      if !SELENIUM_URL.empty?
        Capybara::Selenium::Driver.new(
          app,
          browser: :remote,
          url: SELENIUM_URL,
          options: options,
          http_client: client
        )
      else
        Capybara::Selenium::Driver.new(
          app,
          browser: :chrome,
          options: options,
          http_client: client
        )
      end
    end

    def initialize(driver: :headless_chrome)
      @session = Capybara::Session.new(driver)
    end
  end

  class HeadlessBrowser < Browser
    def initialize
      super(driver: :headless_chrome)
    end
  end
end
