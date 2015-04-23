# setup as development enviroment unless otherwise specified
RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)

namespace :schedule do
  desc "seed database"
  task :order_reminder do
    require './config/application'
    Orders
      .new
      .dataset
      .where(:reminded_at => nil)
      .where{completed_at < (DateTime.now - 3)}
      .each do |record|
        order = Order.new record
        ap order.customer.name
        mailer = CustomerMailer.new order.customer , :application_url => ENV.fetch('APPLICATION_URL')
        mailer.order_reminder(order)
        order.reminder_sent
      end
  end
end
