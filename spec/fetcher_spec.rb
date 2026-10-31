require 'spec_helper'
require 'socket'

module SingDollar
  describe Fetcher do
    subject(:fetcher) { described_class.new }

    let(:success) { instance_double(Process::Status, success?: true) }
    let(:failure) { instance_double(Process::Status, success?: false) }
    let(:commands) { [] }
    let(:json) do
      JSON.generate(
        'fxRatesSgd' => [{ 'baseCurrencyCode' => 'USD' }],
        'lastUpdated' => '2026-10-30T07:00:14'
      )
    end

    before do
      allow(fetcher).to receive(:puts)
      allow(Open3).to receive(:capture3) do |*command|
        commands << command
        command.last == described_class::EXCHANGE_RATES_PAGE_URL ? ['', '', success] : [json, '', success]
      end
    end

    it 'returns the original feed JSON' do
      expect(fetcher.fetch_exchange_rates_json).to eq(json)
    end

    it 'fetches rates with real curl after a page returns HTTP 403 and sets a cookie' do
      server = TCPServer.new('127.0.0.1', 0)
      base_url = "http://127.0.0.1:#{server.addr[1]}"
      stub_const('SingDollar::Fetcher::EXCHANGE_RATES_PAGE_URL', "#{base_url}/page")
      stub_const('SingDollar::Fetcher::EXCHANGE_RATES_JSON_URL', "#{base_url}/feed")
      allow(Open3).to receive(:capture3).and_call_original
      response_json = json
      requests = []

      worker = Thread.new do
        2.times do |index|
          connection = server.accept
          begin
            request = []
            while (line = connection.gets) && line != "\r\n"
              request << line
            end
            requests << request

            if index.zero?
              status = '403 Forbidden'
              cookie = "Set-Cookie: ocbc_session=accepted; Path=/\r\n"
              body = 'Access denied'
            else
              has_cookie = request.any? { |line| line.match?(/^Cookie:.*ocbc_session=accepted/i) }
              status = has_cookie ? '200 OK' : '403 Forbidden'
              cookie = ''
              body = response_json
            end

            connection.write("HTTP/1.1 #{status}\r\n#{cookie}" \
                             "Content-Length: #{body.bytesize}\r\nConnection: close\r\n\r\n#{body}")
          ensure
            connection.close
          end
        end
      end

      expect(fetcher.fetch_exchange_rates_json).to eq(response_json)
      worker.value
      expect(requests.map { |request| request.first.split[1] }).to eq(['/page', '/feed'])
    ensure
      worker&.kill
      worker&.join
      server&.close
    end

    it 'visits the page before the feed without rejecting an HTTP error from the page' do
      fetcher.fetch_exchange_rates_json

      expect(commands.map(&:last)).to eq([
        described_class::EXCHANGE_RATES_PAGE_URL,
        described_class::EXCHANGE_RATES_JSON_URL
      ])
      expect(commands.first).not_to include('--fail')
      expect(commands.first).to include('--output', File::NULL)
      expect(commands.last).to include('--fail')
    end

    it 'shares a private cookie file between requests and deletes it afterwards' do
      cookie_path = nil
      allow(Open3).to receive(:capture3) do |*command|
        path = command[command.index('--cookie-jar') + 1]
        expect(command[command.index('--cookie') + 1]).to eq(path)
        expect(File.stat(path).mode & 0o777).to eq(0o600)

        if command.last == described_class::EXCHANGE_RATES_PAGE_URL
          cookie_path = path
          File.write(path, 'test session cookie')
          ['', '', success]
        else
          expect(path).to eq(cookie_path)
          expect(File.read(path)).to eq('test session cookie')
          [json, '', success]
        end
      end

      fetcher.fetch_exchange_rates_json

      expect(File.exist?(cookie_path)).to be(false)
    end

    it 'uses separate cookie files for independent fetches' do
      2.times { fetcher.fetch_exchange_rates_json }

      paths = commands.map { |command| command[command.index('--cookie') + 1] }
      expect(paths[0]).to eq(paths[1])
      expect(paths[2]).to eq(paths[3])
      expect(paths[0]).not_to eq(paths[2])
    end

    it 'bounds both requests and uses the tested user agent' do
      fetcher.fetch_exchange_rates_json

      commands.each do |command|
        expect(command.first).to eq('curl')
        expect(command).to include('--connect-timeout', '10', '--max-time', '20')
        expect(command).to include('--user-agent', 'Mozilla/5.0', '--location')
      end
    end

    it 'reports a feed HTTP error and deletes the cookie file' do
      allow(Open3).to receive(:capture3).and_return(
        ['', '', success], ['', 'curl: (22) HTTP 403', failure]
      )
      cookie_path = nil
      allow(Tempfile).to receive(:create).and_wrap_original do |original, *arguments, &block|
        original.call(*arguments) do |file|
          cookie_path = file.path
          block.call(file)
        end
      end

      expect { fetcher.fetch_exchange_rates_json }
        .to raise_error(Fetcher::FetchError, /HTTP 403/)
      expect(File.exist?(cookie_path)).to be(false)
    end

    it 'stops if the page request fails to connect' do
      allow(Open3).to receive(:capture3).and_return(['', 'curl: (28) timed out', failure])

      expect { fetcher.fetch_exchange_rates_json }
        .to raise_error(Fetcher::FetchError, /timed out/)
      expect(Open3).to have_received(:capture3).once
    end

    it 'explains when curl is not installed' do
      allow(Open3).to receive(:capture3).and_raise(Errno::ENOENT)

      expect { fetcher.fetch_exchange_rates_json }
        .to raise_error(Fetcher::FetchError, /curl must be installed/)
    end

    it 'rejects an HTML rejection page even when the request succeeds' do
      allow(Open3).to receive(:capture3).and_return(
        ['', '', success], ['<html>Access denied</html>', '', success]
      )

      expect { fetcher.fetch_exchange_rates_json }
        .to raise_error(Fetcher::FetchError, /not valid JSON/)
    end

    it 'rejects JSON without nonempty rates and an update timestamp' do
      [nil, [], {}, { 'fxRatesSgd' => [], 'lastUpdated' => '2026-10-30' },
       { 'fxRatesSgd' => [{}] }].each do |data|
        allow(Open3).to receive(:capture3).and_return(
          ['', '', success], [JSON.generate(data), '', success]
        )

        expect { fetcher.fetch_exchange_rates_json }
          .to raise_error(Fetcher::FetchError, /does not contain exchange rates/)
      end
    end
  end
end
