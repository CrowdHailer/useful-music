class MyMiddleware
  def initialize(bugsnag)
    @bugsnag = bugsnag
  end

  def call(notification)
    # Your custom "before notify" code

    @bugsnag.call(notification)
    ap notification
    env = notification.request_data[:rack_env]
    ap env
    if env
      request = ::Rack::Request.new(env)
      # ap request.session
      session = env["rack.session"]
      customer = Customers.find(session[:user_id]) || Guest.new
      ap custom
      notification.user = {:email => customer.email, :customer.id}

    end
    # Your custom "after notify" code
  end
end

Bugsnag.configure do |config|
  config.api_key = ENV.fetch('BUGSNAG_API_KEY')
  config.project_root = File.expand_path('../..', __FILE__)
  config.middleware.use MyMiddleware
end
