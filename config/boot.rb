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

# require the lib directory
Dir[APP_ROOT + '/lib/*.rb'].each {|file| require file }
Dir[APP_ROOT + '/lib/**/*.rb'].each {|file| require file }
