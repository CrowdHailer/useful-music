Bugsnag.configure do |config|
  config.api_key = ENV.fetch('BUGSNAG_API_KEY')
end
Bugsnag.before_notify_callbacks << lambda {|notif|
  notif.add_tab(:user_info, {
    name: current_customer.name
  })
}
