require 'simplecov'
SimpleCov.start

require 'mad_chatter'
require 'rspec/mocks'

# See http://rubydoc.info/gems/rspec-mocks/frames for more details on
# the API.
## Don't like RSpec mocks? See: https://www.relishapp.com/rspec/rspec-core/docs/mock-framework-integration/mock-with-rspec
RSpec.configure do |config|
  config.mock_framework = :rspec
end


