class UserTracking
  def initialize(bugsnag)
    @bugsnag = bugsnag
  end

  def call(notification)
    env = notification.request_data[:rack_env]
    if env
      session = env["rack.session"] || {}
      user = Customers.fetch(session[:user_id]) { Guest.new session }
      notification.user = {
        :id => user.id,
        :email => user.email,
        :name => user.name
      }
    end

    @bugsnag.call(notification)
  end
end

Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_API_KEY']
  config.project_root = File.expand_path('../..', __FILE__)
  config.notify_release_stages = ["production", "staging"]
  config.middleware.use UserTracking
end
