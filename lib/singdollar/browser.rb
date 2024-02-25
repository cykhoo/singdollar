module SingDollar

  class Browser

    attr_reader :session

    require 'capybara'
    require 'selenium/webdriver'

    chrome_options = Selenium::WebDriver::Chrome::Options.new
    chrome_options.add_option("excludeSwitches", ["enable-automation"])

    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
    end

    Capybara.register_driver :headless_chrome do |app|
      chrome_options.add_argument('--headless')
      chrome_options.add_argument('--no-sandbox')
      chrome_options.add_argument('--disable-dev-shm-usage')
      Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
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
