require_relative '../test_config'

class AuthenticationControllerTest < MyRecordTest
  include ControllerTesting
  include Warden::Test::Helpers

  def app
    AuthenticationController
  end

  def test_login_page_is_available
    assert_ok get '/login'
  end

  def test_can_login
    email = 'test@example.com'
    password = 'password'
    record = create :customer_record, :email => email, :password => password
    post '/login?attempted_path=/private', :email => email, :password => password, :attempted_path => '/private'
    ap last_response.location
    get '/private'
    # ap last_response.status

  end

  def test_auth
    get '/private'
    # ap last_response.location
  end
  #
  # def test_authy
  #   customer = Customer.new(FactoryGirl.create :customer_record)
  #   # login_as customer
  #   get '/private'
  # end

  # def test_login
  #   post '/', :email => 'test@example.com', :password => 'password'
  #   get '/private'
  # end
end
