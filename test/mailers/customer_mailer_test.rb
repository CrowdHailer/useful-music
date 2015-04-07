require_relative '../test_config'

class CustomerMailerTest < MyRecordTest
  include MailerTesting

  def customer
    @customer ||= MiniTest::Mock.new
  end

  def mailer
    @mailer ||= CustomerMailer.new customer, :application_url => 'www.example.com'
  end

  def setup
    clear_mail
  end

  def teardown
    @customer = nil
    @mailer = nil
  end

  def test_case_name
    # Duplicated as called for plain and HTML
    customer.expect :name, 'Rodger Rabbit'
    customer.expect :name, 'Rodger Rabbit'
    customer.expect :email, 'test@example.com'
    customer.expect :id, 'some-unique-identifier'
    customer.expect :id, 'some-unique-identifier'
    mailer.account_created
    assert_includes last_message.text_part.body, 'Rodger Rabbit'
    assert_includes last_message.to, 'test@example.com'
  end
end
