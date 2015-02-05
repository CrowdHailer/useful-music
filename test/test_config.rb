# Setup rack enviroment to test unless specified
RACK_ENV = 'test' unless defined?(RACK_ENV)

require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

reporter_options = {color: true, slow_count: 5}
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

# Could be moved to individual test files for setup speed
require File.expand_path('../../config/application', __FILE__)

module ControllerTesting
  def self.included(klass)
   klass.include Rack::Test::Methods
  end

  def assert_ok(response=last_response)
    assert response.ok?, "Response was #{last_response.status} not OK"
  end
end
