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
    assert_includes last_message.body, 'password_resets'
    assert_equal 'A password reset as been sent to your email', flash['success']
  end

  def test_rerenders_when_email_not_found
    assert_ok post '/', :customer => {:email => 'a@b.com'}
    assert_includes last_response.body, 'Email not found'
  end

  def test_edit_page_available_for_known_email
    email = customer.email
    token = customer.create_password_reset
    customer.record.save
    assert_ok get "/#{token}/edit", {:email => email}
  end

  def test_can_reset_password
    email = customer.email
    token = customer.create_password_reset
    customer.record.save
    put "/#{token}", {:email => email, :customer => {
      :password => 'new',
      :password_confirmation => 'new'
    }}
    
  end
end
