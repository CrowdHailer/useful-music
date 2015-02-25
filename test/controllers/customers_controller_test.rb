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

  def customer_email
    'customer@example.com'
  end

  def customer
    @customer ||= Customer.new(create :customer_record, :email => customer_email)
  end

  def admin_email
    'admin@example.com'
  end

  def admin
    @admin ||= Customer.new(create :customer_record, :admin, :email => admin_email)
  end

  def interloper_email
    'interloper@example.com'
  end

  def interloper
    @interloper ||= Customer.new(create :customer_record, :email => interloper_email)
  end

  def test_index_page_is_available_to_admin
    assert_ok get '/', {}, {'rack.session' => { :user_id => admin.id }}
    assert_includes last_response.body, admin_email
  end

  def test_index_page_is_not_available_to_non_admin
    get '/', {}, {'rack.session' => { :user_id => interloper.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
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
    get "/1", {}, {'rack.session' => {:user_id => admin.id}}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_show_page_is_unavailable_to_inerloper
    get "/#{customer.id}", {}, {'rack.session' => {:user_id => interloper.id}}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_show_page_is_unavailable_when_not_logged_in
    get "/#{customer.id}"
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_show_page_is_available_to_that_customer
    assert_ok get "/#{customer.id}", {}, {'rack.session' => {:user_id => customer.id}}
    assert_includes last_response.body, customer_email
  end

  def test_show_page_is_available_to_admin
    assert_ok get "/#{customer.id}", {}, {'rack.session' => {:user_id => admin.id}}
    assert_includes last_response.body, customer_email
  end

  def test_edit_page_is_unavailable_when_no_customer
    get "/1/edit", {}, {'rack.session' => {:user_id => admin.id}}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_edit_page_is_unavailable_to_inerloper
    get "/#{customer.id}/edit", {}, {'rack.session' => {:user_id => interloper.id}}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_edit_page_is_unavailable_when_not_logged_in
    get "/#{customer.id}/edit"
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_edit_page_is_available_to_that_customer
    assert_ok get "/#{customer.id}/edit", {}, {'rack.session' => {:user_id => customer.id}}
    assert_includes last_response.body, customer_email
  end

  def test_edit_page_is_available_to_admin
    assert_ok get "/#{customer.id}/edit", {}, {'rack.session' => {:user_id => admin.id}}
    assert_includes last_response.body, customer_email
  end

  def test_update_is_unavailable_when_no_customer
    put "/1", {}, {'rack.session' => {:user_id => admin.id}}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_update_is_unavailable_to_inerloper
    put "/#{customer.id}", {}, {'rack.session' => {:user_id => interloper.id}}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_update_is_unavailable_when_not_logged_in
    put "/#{customer.id}"
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_update_is_available_to_that_customer
    put "/#{customer.id}",
      {:customer => customer.record.values.merge(:first_name => 'Enrique')},
      {'rack.session' => {:user_id => customer.id}}
    assert_match(/#{customer.id}/, last_response.location)
    assert_equal 'Enrique', Customers.last.first_name
  end

  def test_update_is_available_to_admin
    put "/#{customer.id}",
      {:customer => customer.record.values.merge(:first_name => 'Enrique')},
      {'rack.session' => {:user_id => admin.id}}
    assert_match(/#{customer.id}/, last_response.location)
    assert_equal 'Enrique', customer.record.reload.first_name
  end

  def test_destroy_is_unavailable_when_no_customer
    delete "/1", {}, {'rack.session' => {:user_id => admin.id}}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_destroy_is_unavailable_to_inerloper
    delete "/#{customer.id}", {}, {'rack.session' => {:user_id => interloper.id}}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_destroy_is_unavailable_when_not_logged_in
    delete "/#{customer.id}"
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_destroy_is_available_to_that_customer
    delete "/#{customer.id}", {}, {'rack.session' => {:user_id => customer.id}}
    assert_nil Customers.find customer.id
    assert_match(/customers/, last_response.location)
  end

  def test_destroy_is_available_to_admin
    delete "/#{customer.id}", {}, {'rack.session' => {:user_id => admin.id}}
    assert_nil Customers.find customer.id
    assert_match(/customers/, last_response.location)
  end

end
