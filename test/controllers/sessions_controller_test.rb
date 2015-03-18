require_relative '../test_config'

class SessionsControllerTest < MyRecordTest
  include ControllerTesting
  include MailerTesting

  def app
    SessionsController
  end

  def email
    'test@example.com'
  end

  def password
    'password'
  end

  def test_new_page_is_available
    assert_ok get '/new'
  end

  def test_redirect_to_account_if_logged_in
    customer_record = create :customer_record
    get '/new', {}, {'rack.session' => { :user_id => customer_record.id }}
    assert_includes last_response.location, customer_record.id
  end

  def test_render_login_form_when_credentials_invalid
    post '/'
    assert_equal 'Invalid login details', flash['error']
  end

  def test_logs_in_with_valid_params
    customer_record = create :customer_record, :email => email, :password => password
    post '/', :session => {:email => email, :password => password}
    assert_includes last_response.location, customer_record.id
    assert_equal customer_record.id, last_request.env['rack.session'][:user_id]
    assert_equal "Welcome back #{customer_record.first_name} #{customer_record.last_name}", flash['success']
  end

  def test_redirects_to_requested_path_if_given
    customer_record = create :customer_record, :email => email, :password => password
    post '/', {:session => {:email => email, :password => password}, :requested_path => '/admin'}
    assert_equal '/admin', last_response.location
  end

  def test_takes_session_basket
    shopping_basket_record = create :shopping_basket_record
    purchase_record = create :purchase_record, :shopping_basket_record => shopping_basket_record
    customer_record = create :customer_record, :email => email, :password => password
    post '/', {:session => {:email => email, :password => password}}, {'rack.session' => { 'guest.shopping_basket' => shopping_basket_record.id }}
    assert_equal shopping_basket_record, customer_record.reload.shopping_basket_record
  end

  def test_uses_customer_existing_basket_when_session_empty
    shopping_basket_record = create :shopping_basket_record
    purchase_record = create :purchase_record, :shopping_basket_record => shopping_basket_record
    customer_record = create :customer_record, :email => email, :password => password, :shopping_basket_record => shopping_basket_record
    post '/',
      {:session => {:email => email, :password => password}},
      {'rack.session' => {
        'guest.shopping_basket' => create(:shopping_basket_record).id
      }
    }
    assert_equal shopping_basket_record, customer_record.reload.shopping_basket_record
  end

  def test_can_log_out
    customer_record = create :customer_record
    delete '/', {}, {'rack.session' => { :user_id => customer_record.id }}
    assert_nil last_request.env['rack.session'][:user_id]
  end
end
