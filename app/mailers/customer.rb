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
    mail.subject 'Welcome to usefulmusic.com'
    text_body = render __method__
    text_part = Mail::Part.new do
      body text_body
    end

    html_body = render __method__, :extension => 'html'
    html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body html_body
    end

    mail.text_part = text_part
    mail.html_part = html_part
    mail.deliver
  end

  def password_reset_created
    mail = Mail.new
    mail.from 'info@usefulmusic.com'
    mail.to @customer.email
    mail.subject 'Useful Music password reset'
    text_body = render __method__
    text_part = Mail::Part.new do
      body text_body
    end

    html_body = render __method__, :extension => 'html'
    html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body html_body
    end

    mail.text_part = text_part
    mail.html_part = html_part
    mail.deliver
  end

  def order_successful
    mail = Mail.new
    mail.from '<UsefulMusic>orders@usefulmusic.com'
    mail.to @customer.email
    mail.subject 'Your Order at Useful Music'
    text_body = render __method__
    text_part = Mail::Part.new do
      body text_body
    end

    html_body = render __method__, :extension => 'html'
    html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body html_body
    end

    mail.text_part = text_part
    mail.html_part = html_part
    mail.deliver
  end

  def order_reminder(order)
    mail = Mail.new
    mail.from '<UsefulMusic>orders@usefulmusic.com'
    mail.to @customer.email
    mail.subject 'Your recent sheet music order - a reminder'

    text_body = render __method__
    text_part = Mail::Part.new do
      body text_body
    end

    html_body = render __method__, :extension => 'html'
    html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body html_body
    end

    mail.text_part = text_part
    mail.html_part = html_part
    mail.deliver
  end

  def locals
    OpenStruct.new(:customer => customer, :account_url => account_url, :application_url => options.fetch(:application_url))
  end

  def account_url
    File.join(options.fetch(:application_url), 'customers', customer.id)
  end

  def render(file, **options)
    extension = options.fetch(:extension, 'txt')
    template = Tilt::ERBTemplate.new(template_file(file, extension))
    template.render locals
  end

  def template_file(file, extension)
    File.expand_path("customer/#{file}.#{extension}.erb", File.dirname(__FILE__))
  end
end
