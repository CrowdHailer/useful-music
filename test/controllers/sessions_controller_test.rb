require_relative '../test_config'

class SessionsControllerTest < MyRecordTest
  include ControllerTesting
  include MailerTesting

  def app
    SessionsController
  end

  def test_new_page_is_available
    assert_ok get '/new'
  end

  def test_redirect_to_account_if_logged_in
    skip
  end

  def test_render_login_form_when_credentials_invalid
    post '/'
    assert_equal 'Invalid login details', flash['error']
  end

  def test_logs_in_with_valid_params
    customer_record = create :customer_record, :email => 'test@example.com', :password => 'password'
    post '/', :session => {:email => 'test@example.com', :password => 'password'}
    assert_includes last_response.location, customer_record.id
    assert_equal customer_record.id, last_request.env['rack.session'][:user_id]
    assert_equal "Welcome back #{customer_record.first_name} #{customer_record.last_name}", flash['success']
  end
end
