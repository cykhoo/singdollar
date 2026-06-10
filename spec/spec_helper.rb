require 'bundler'
Bundler.setup(:default, :development)

require 'singdollar'
require 'rspec'
require 'factory_bot'

FactoryBot.find_definitions

RSpec.configure do |config|
  config.order = 'random'
end
