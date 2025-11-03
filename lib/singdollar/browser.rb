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

    # normal chrome (can be remote or local)
    Capybara.register_driver :chrome do |app|
      options = chrome_options(headless: false)
      if !SELENIUM_URL.empty?
        Capybara::Selenium::Driver.new(app, browser: :remote, url: SELENIUM_URL, options: options)
      else
        Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
      end
    end

    # headless chrome (can be remote or local)
    Capybara.register_driver :headless_chrome do |app|
      options = chrome_options(headless: true)
      if !SELENIUM_URL.empty?
        Capybara::Selenium::Driver.new(app, browser: :remote, url: SELENIUM_URL, options: options)
      else
        Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
      end
    end

    Capybara.default_driver = :headless_chrome
    Capybara.javascript_driver = :headless_chrome
    Capybara.default_max_wait_time = 30

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
