class CustomerMailer
  def initialize(customer, options)
    @customer = customer
    @options = options
    @templates = File.join(APP_ROOT, 'app', 'views', 'customer_mailer')
  end

  def confirm_account
    mail = Mail.new
    mail.from 'info@usefulmusic.com'
    mail.to @customer.email
    mail.subject 'Here is a message'
    mail.body %Q{
      Your Account is now available at Useful Music
      #{File.join(@options.fetch(:application_url), 'customers', @customer.id)}
    }
    mail.deliver

  end
end
