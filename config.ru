require File.expand_path("../config/application.rb", __FILE__)

use Bugsnag::Rack

run UsefulMusic::App
