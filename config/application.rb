require File.expand_path("../boot.rb", __FILE__)

module UsefulMusic
  class App < Scorched::Controller
    render_defaults[:dir] = File.expand_path('app/views', APP_ROOT)
    render_defaults[:layout] = File.expand_path('app/views/application', APP_ROOT).to_sym
  end
end

# Load all controllers
Dir[File.expand_path('app/controllers/*.rb', APP_ROOT)].each { |file| require file}

class UsefulMusic::App
  controller '/', HomeController
end
