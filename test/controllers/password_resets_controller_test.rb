require_relative '../test_config'

class PasswordResetsControllerTest < MyRecordTest
  include ControllerTesting
  include MailerTesting


  def app
    Mail.defaults do
      delivery_method :test
    end
    PasswordResetsController
  end

  def test_new_page_is_available
    assert_ok get '/new'
  end

  def test_create_reset
    post '/', :customer => {:email => customer.email}
    assert_match(/sessions\/new/, last_response.location)
    assert_includes last_message.to, last_customer.email
    assert_includes last_message.body, last_customer.password_reset_token
    assert_equal 'A password reset as been sent to your email', flash['success']
  end

  def test_rerenders_when_email_not_found
    assert_ok post '/', :customer => {:email => 'a@b.com'}
    assert_includes last_response.body, 'Email not found'
  end
end
