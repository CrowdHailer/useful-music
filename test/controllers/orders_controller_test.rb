require_relative '../test_config'

class OrdersControllerTest < MyRecordTest
  include ControllerTesting
  include MailerTesting

  def app
    OrdersController
  end

  def test_redirect_from_create_when_not_signed_in
    post '/'
    assert_equal 'Please Sign in or Create account to checkout purchases', flash['error']
    assert last_response.redirect?
  end

  def test_redirect_if_basket_is_empty
    post '/', {}, {'rack.session' => {:user_id => customer.id}}
    assert_equal 'Your shopping basket is empty', flash['error']
    assert last_response.redirect?
  end
end
