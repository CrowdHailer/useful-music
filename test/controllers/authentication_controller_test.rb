require_relative '../test_config'

class AuthenticationControllerTest < MyRecordTest
  include ControllerTesting
  include Warden::Test::Helpers

  def app
    AuthenticationController
  end

  def test_login_page_is_available
    assert_ok get '/unauthenticated'
  end

  def test_auth
    get '/private'
  end

  def test_authy
    customer = Customer.new(FactoryGirl.create :customer_record)
    # login_as customer
    get '/private'
  end

  def test_login
    post '/', :email => 'test@example.com', :password => 'password'
    get '/private'
    ap last_response.status
    ap last_response.body
  end
end
