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
    skip
    clear_mail
    post '/', :customer => attributes_for(:customer_record).merge(
      :password_confirmation => 'password',
      :terms_agreement => 'on',
      :country => 'GB')

    assert_match(/#{last_customer.id}/, last_response.location)
    assert_includes last_message.to, last_customer.email
    assert_includes last_message.body, last_customer.id
  end

  def test_show_page_is_available
    record = create :customer_record, :email => 'test@example.com'
    assert_ok get "/#{record.id}"
    assert_includes last_response.body, 'test@example.com'
  end

  def test_edit_page_is_available
    record = create :customer_record
    assert_ok get "/#{record.id}/edit"
  end

  def test_can_update_a_customer
    record = create :customer_record
    put "/#{record.id}", :customer => record.values.merge(:first_name => 'Enrique')
    assert_match(/#{record.id}/, last_response.location)
    assert_equal 'Enrique', Customers.last.first_name
  end

  def test_can_destroy_a_customer
    record = create :customer_record
    delete "/#{record.id}"
    assert_empty Customers
    assert_match(/customers/, last_response.location)
  end
end
