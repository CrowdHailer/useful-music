# setup as development enviroment unless otherwise specified
RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)

require 'fileutils'

namespace :server do

  desc "Starts the daemon Thin server and Sass watcher"
  task :processes do
    puts "Start Thin as a daemon and Sass normally"

    system "thin start -d"
    system "sass --watch assets/stylesheets:public/stylesheets --style compressed"
  end

  desc "Stops the daemon Thin server"
  task :stop do
    file = File.open("tmp/pids/thin.pid", "rb")
    process_id = file.read

    puts "Stopping Thin server (process #{process_id})"

    system "kill #{process_id}"

    FileUtils.remove_dir("log") if File.directory? "log"
    FileUtils.remove_dir("tmp") if File.directory? "tmp"
  end

  desc "Starts server at localhost:3000 with Sass enabled"
  task :start => [:processes, :stop] do
    puts "Bye!"
  end

end

namespace :sass do
  desc 'Start watching for Sass changes'
  task :watch do
    system "bundle exec sass --watch assets/stylesheets:public/stylesheets --style compressed"
  end
end
