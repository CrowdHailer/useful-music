# Setup rack enviroment to test unless specified
RACK_ENV = ENV['RACK_ENV'] = 'test' unless defined?(RACK_ENV)

require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

reporter_options = {color: true, slow_count: 5}
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

# Could be moved to individual test files for setup speed
require File.expand_path('../../config/application', __FILE__)

BCrypt::Engine.cost = 1

FactoryGirl.find_definitions
FactoryGirl.to_create { |i| i.save }

class MyRecordTest < MiniTest::Test
  include FactoryGirl::Syntax::Methods

  def run(*args, &block)
    result = nil
    Sequel::Model.db.transaction(:rollback=>:always, :auto_savepoint=>true){result = super}
    result
  end

end

module MailerTesting
  def clear_mail
    require 'mail'
    Mail.defaults do
      delivery_method :test
    end
    Mail::TestMailer.deliveries.clear
  end

  def last_message
    @last_message ||= Mail::TestMailer.deliveries.pop
  end
end

module ControllerTesting
  def self.included(klass)
   klass.include Rack::Test::Methods
  end

  # NOTE http test methods return response
  # can use as follows
  #
  # assert_ok verb '/url'
  #
  def assert_ok(response=last_response)
    assert response.ok?, "Response was #{last_response.status} not OK"
  end

end

CarrierWave.configure do |config|
  config.storage = :file
  config.enable_processing = false
  config.store_dir = 'tmp'
  config.root = 'tmp'
end
# TODO runs everytime
# class MyRecordTest
#   def test_lint_factories
#     FactoryGirl.lint
#   end
# end
