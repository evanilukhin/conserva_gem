require 'bundler/setup'
require 'rspec'
require 'support/fake_conserva_api'
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)
Bundler.setup

require 'conserva'

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /test-conserva-gem:1/).to_rack(FakeConservaAPI)
  end
end