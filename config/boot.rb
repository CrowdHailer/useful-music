# setup as development enviroment unless otherwise specified
RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
# require './test'

# Set Application Root
APP_ROOT = File.expand_path('../../', __FILE__) unless defined?(APP_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)

# Sets up all of load paths that are searched when requiring code
require 'bundler/setup'

# requires all gems for the current runtime enviroment
Bundler.require(:default, RACK_ENV)

# Thread safe loading?
require 'erb'

Dotenv.load

########################################

## Belongs in a config/db.rb file

########################################

DATABASE_URL = ENV.fetch('DATABASE_URL'){
  "postgres://localhost/useful_music_#{RACK_ENV}"
}
Sequel::Model.plugin(:schema)
Sequel.connect(DATABASE_URL)

######### END ###########

########################################

## Belongs in a config/warden.rb file

########################################
Warden::Manager.before_failure do |env, opts|
  env['REQUEST_METHOD'] = 'POST'
end

Warden::Strategies.add(:password) do
  def valid?
    request.POST['email'] && request.POST['password']
  end

  def authenticate!
    owner = Customers.authenticate(request.POST['email'], request.POST['password'])
    owner ? success!(owner, "Welcome back: #{owner.email}") : fail!('no luck jimmey')
  end
end

######### END ###########

########################################

## Belongs in a config/carrierwave.rb file

########################################

CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_bucket = ENV.fetch('S3_BUCKET_NAME')
  config.aws_acl    = :public_read
  # config.asset_host = 'http://example.com'
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
  }
end

######### END ############

########################################

## Belongs in a config/paypal.rb file

########################################

Paypal.sandbox!

######### END ############

########################################

## Belongs in a config/paypal.rb file

########################################

Mail.defaults do
  delivery_method :smtp,
    address: 'smtp.mandrillapp.com',
    port: 587,
    domain: 'herokuapp.com',
    user_name: ENV.fetch('MANDRILL_USERNAME'),
    password: ENV.fetch('MANDRILL_APIKEY'),
    authentication: 'plain',
    :enable_starttls_auto => true
end

######### END ############

########################################

## Belongs in a config/money.rb file

########################################

Money.default_currency = Money::Currency.new("GBP")

######### END ###########

# # require the lib directory
# TODO either move entities into namespace module or set requirements as tree
Dir[APP_ROOT + '/lib/*.rb'].each {|file| require file }
Dir[APP_ROOT + '/lib/**/*.rb'].each {|file| require file }
