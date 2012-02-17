unless ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

require 'mad_chatter'
require 'rspec/mocks'

RSpec.configure do |config|
  config.mock_framework = :rspec
end
