require_relative '../test_config'

class CustomersControllerTest < MyRecordTest
  include ControllerTesting
  include MailerTesting

  def app
    CustomersController
  end

  def last_customer
    Customers.last
  end

  def test_index_page_is_available
    create :customer_record, :email => 'test@example.com'
    assert_ok get '/'
    assert_includes last_response.body, 'test@example.com'
  end

  def test_new_page_is_available
    assert_ok get '/new'
  end

  def test_can_create_customer
    clear_mail
    post '/', :customer => attributes_for(:customer_record).merge(
      :password_confirmation => 'password',
      :terms_agreement => 'on',
      :country => 'GB')

    assert_match(/#{last_customer.id}/, last_response.location)
    assert_includes last_message.to, last_customer.email
    assert_includes last_message.body, last_customer.id
    assert_equal 'Welcome to Useful Music', flash['success']
  end

  def test_show_page_is_unavailable_when_no_customer
    get "/1"
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_show_page_is_unavailable_when_not_logged_in
    customer_record = create :customer_record, :email => 'test@example.com'
    get "/#{customer_record.id}"
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_show_page_is_available_to_that_customer
    customer_record = create :customer_record, :email => 'test@example.com'
    assert_ok get "/#{customer_record.id}", {}, {'rack.session' => { :user_id => customer_record.id }}
    assert_includes last_response.body, 'test@example.com'
  end

  def test_edit_page_is_available
    customer_record = create :customer_record
    assert_ok get "/#{customer_record.id}/edit"
  end

  def test_can_update_a_customer
    customer_record = create :customer_record
    put "/#{customer_record.id}", :customer => customer_record.values.merge(:first_name => 'Enrique')
    assert_match(/#{customer_record.id}/, last_response.location)
    assert_equal 'Enrique', Customers.last.first_name
  end

  def test_can_destroy_a_customer
    customer_record = create :customer_record
    delete "/#{customer_record.id}"
    assert_empty Customers
    assert_match(/customers/, last_response.location)
  end
end
