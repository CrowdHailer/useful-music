Bugsnag.configure do |config|
  config.api_key = ENV.fetch('BUGSNAG_API_KEY')
  config.project_root = File.expand_path('../..', __FILE__)
end
