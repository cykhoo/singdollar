module SingDollar

  class Fetcher
    require 'json'
    require 'open3'
    require 'tempfile'

    EXCHANGE_RATES_PAGE_URL = 'https://www.ocbc.com/business-banking/foreign-exchange-rates'
    EXCHANGE_RATES_JSON_URL = 'https://www.ocbc.com/fxrates/bootstrap.json'

    class FetchError < StandardError; end

    def fetch_exchange_rates_json
      puts "Fetching exchange rates JSON..."

      Tempfile.create('singdollar-ocbc-cookies') do |cookies|
        options = [
          '--silent', '--show-error', '--location',
          '--connect-timeout', '10', '--max-time', '20',
          '--user-agent', 'Mozilla/5.0',
          '--cookie-jar', cookies.path, '--cookie', cookies.path
        ]

        # OCBC can set the required cookies even when this page returns HTTP 403.
        run_curl(*options, '--output', File::NULL, EXCHANGE_RATES_PAGE_URL)
        json = run_curl(*options, '--fail', EXCHANGE_RATES_JSON_URL)
        validate_json(json)
        json
      end
    end

    private

    def run_curl(*arguments)
      output, error, status = Open3.capture3('curl', *arguments)
      raise FetchError, "OCBC request failed: #{error.strip}" unless status.success?

      output
    rescue Errno::ENOENT
      raise FetchError, 'curl must be installed to fetch OCBC exchange rates'
    end

    def validate_json(json)
      data = JSON.parse(json)
      return if data.is_a?(Hash) &&
                data['fxRatesSgd'].is_a?(Array) && !data['fxRatesSgd'].empty? &&
                data['lastUpdated'].is_a?(String) && !data['lastUpdated'].empty?

      raise FetchError, 'OCBC response does not contain exchange rates and an update timestamp'
    rescue JSON::ParserError
      raise FetchError, 'OCBC response is not valid JSON'
    end
  end
end
