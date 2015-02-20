require_relative '../test_config'

class CustomerMailerTest < MyRecordTest
  include MailerTesting

  def test_case_name
    mailer = CustomerMailer.new OpenStruct.new(:email => 'test@example.com'),
      :application_url => 'www.example.com'
    mailer.new_account
  end
end
