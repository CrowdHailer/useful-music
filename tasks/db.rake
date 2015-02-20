# setup as development enviroment unless otherwise specified
RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)

namespace :db do
  require "sequel"

  # Generate project specific database urls if none provided
  DATABASE_URL = ENV.fetch('DATABASE_URL'){
    "postgres://localhost/useful_music_#{RACK_ENV}"
  }
  Sequel.extension :migration
  DB = Sequel.connect(DATABASE_URL)

  namespace :migrate do

    desc "Perform migration reset (full erase and migration up)"
    task :reset do
      Sequel::Migrator.run(DB, "db/migrations", :target => 0)
      Sequel::Migrator.run(DB, "db/migrations")
      puts "<= sq:migrate:reset executed"
    end

    desc "Perform migration up/down to VERSION"
    task :to do
      version = ENV['VERSION'].to_i
      raise "No VERSION was provided" if version.nil?
      Sequel::Migrator.run(DB, "db/migrations", :target => version)
      puts "<= sq:migrate:to version=[#{version}] executed"
    end

    desc "Perform migration up to latest migration available"
    task :up do
      Sequel::Migrator.run(DB, "db/migrations")
      puts "<= sq:migrate:up executed"
    end

    desc "Perform migration down (erase all data)"
    task :down do
      Sequel::Migrator.run(DB, "db/migrations", :target => 0)
      puts "<= sq:migrate:down executed"
    end
  end

  desc "seed database"
  task :seed do
    require './config/application'
    require './db/seed'
  end
end
