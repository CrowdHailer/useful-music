class CustomerMailer
  def initialize(customer, options={})
    @customer = customer
    @options = options
  end

  attr_reader :customer, :options

  def account_created
    mail = Mail.new
    mail.from 'info@usefulmusic.com'
    mail.to @customer.email
    mail.subject 'Here is a message'
    mail.body render __method__
    mail.deliver
  end

  def password_reset_created
    mail = Mail.new
    mail.from 'info@usefulmusic.com'
    mail.to @customer.email
    mail.subject 'Useful Music password reset'
    mail.body render __method__
    mail.deliver
  end

  def locals
    OpenStruct.new(:customer => customer, :account_url => account_url, :application_url => options.fetch(:application_url))
  end

  def account_url
    File.join(options.fetch(:application_url), 'customers', customer.id)
  end

  def render(file)
    template = Tilt::ERBTemplate.new(template_file(file))
    template.render locals
  end

  def template_file(file)
    File.expand_path("customer/#{file}.erb", File.dirname(__FILE__))
  end
end
