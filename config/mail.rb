Mail.defaults do
  delivery_method :smtp,
    address: 'smtp.mandrillapp.com',
    port: 587,
    domain: 'herokuapp.com',
    user_name: ENV.fetch('MANDRILL_USERNAME'),
    password: ENV.fetch('MANDRILL_APIKEY'),
    authentication: 'plain',
    :enable_starttls_auto => true
end
