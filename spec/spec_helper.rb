require 'bundler'
Bundler.setup(:default, :development)

require 'singdollar'
require 'rspec'
require 'vcr'
require 'yaml'
require 'open-uri'
require 'factory_bot'

FactoryBot.find_definitions

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
  config.default_cassette_options = { match_requests_on: [:body] }
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.order = 'random'
end
