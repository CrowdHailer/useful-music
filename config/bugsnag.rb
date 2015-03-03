class UserTracking
  def initialize(bugsnag)
    @bugsnag = bugsnag
  end

  def call(notification)
    env = notification.request_data[:rack_env]
    if env
      session = env["rack.session"] || {}
      Customers.find(session[:user_id]) || Guest.new
      notification.user = {

      }
    end

    @bugsnag.call(notification)
  end
end

Bugsnag.configure do |config|
  config.api_key = ENV.fetch('BUGSNAG_API_KEY')
  config.project_root = File.expand_path('../..', __FILE__)
  config.middleware.use UserTracking
end
