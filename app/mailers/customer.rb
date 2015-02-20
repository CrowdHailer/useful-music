class CustomerMailer
  def initialize(customer, options={})
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

  def new_account
    # account_created
    # create account confirmation
    render :new_account
  end

  def locals
    OpenStruct.new(:customer => @customer, :application_url => @options.fetch(:application_url))
  end

  def render(file)
    template = Tilt::ERBTemplate.new(template_file(file))
    ap template.render locals
  end

  def template_file(file)
    ap File.dirname(__FILE__)
    File.expand_path("../customer/#{file}.erb", __FILE__)
  end
end
