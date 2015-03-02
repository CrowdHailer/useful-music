Bugsnag.configure do |config|
  config.api_key = ENV.fetch('BUGSNAG_API_KEY')
end
# Bugsnag.before_notify_callbacks << lambda {|notif|
#   notif.user = {
#     id: current_customer.id,
#     email: current_customer.email,
#     name: current_customer.name
#   }
# }
