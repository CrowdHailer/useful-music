require_relative '../test_config'

class CustomersControllerTest < MyRecordTest
  include ControllerTesting
  include MailerTesting

  def app
    CustomersController
  end

  def test_orders_page_is_available_to_that_customer
    assert_ok get "/#{customer.id}/orders", {}, {'rack.session' => {:user_id => customer.id}}
    assert_includes last_response.body, customer.name
  end

  def test_edit_page_is_available_to_that_customer
    assert_ok get "/#{customer.id}/edit", {}, {'rack.session' => {:user_id => customer.id}}
    assert_includes last_response.body, customer.email

  def test_update_is_available_to_that_customer
    put "/#{customer.id}",
      {:customer => customer.record.values.merge(:first_name => 'Enrique')},
      {'rack.session' => {:user_id => customer.id}}
    assert_match(/#{customer.id}/, last_response.location)
    assert_equal 'Enrique', Customers.last.first_name
  end

  def test_destroy_is_available_to_that_customer
    delete "/#{customer.id}", {}, {'rack.session' => {:user_id => customer.id}}
    assert_nil Customers[customer.id]
    assert_match(/customers/, last_response.location)
  end

  def test_edit_password_page_is_available_to_customer
    assert_ok get "/#{customer.id}/change_password", {}, {'rack.session' => {:user_id => customer.id}}
    assert_includes last_response.body, customer.name
  end

  def test_update_password_is_available_to_that_customer
    customer.password = 'password'
    customer.record.save
    put "/#{customer.id}/change_password",
      {:customer => {
          :current_password => 'password',
          :password => 'new',
          :password_confirmation => 'new'
      }},
      {'rack.session' => {:user_id => customer.id}}
    assert Customers.authenticate(customer.email, 'new')
    assert_equal 'Password changed', flash['success']
  end

end
