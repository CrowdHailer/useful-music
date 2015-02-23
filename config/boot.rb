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

# requires all other configuration
Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

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

# # require the lib directory
# TODO either move entities into namespace module or set requirements as tree
Dir[APP_ROOT + '/lib/*.rb'].each {|file| require file }
Dir[APP_ROOT + '/lib/**/*.rb'].each {|file| require file }
