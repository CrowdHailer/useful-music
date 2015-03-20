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

  def test_redirect_with_expired_discount
    discount_record = create :discount_record, :end_datetime => DateTime.new(2014)
    shopping_basket_record = create :shopping_basket_record, :discount_record => discount_record
    shopping_basket_record.add_purchase_record create :purchase_record
    customer.record.update(:shopping_basket_record => shopping_basket_record)
    post '/', {}, {'rack.session' => {:user_id => customer.id}}
    assert_equal 'Your discount has expired', flash['error']
    assert last_response.redirect?
    assert_nil shopping_basket_record.reload.discount_record
  end

  def test_redirect_with_pending_discount
    discount_record = create :discount_record, :end_datetime => DateTime.new(2016), :start_datetime => DateTime.new(2016)
    shopping_basket_record = create :shopping_basket_record, :discount_record => discount_record
    shopping_basket_record.add_purchase_record create :purchase_record
    customer.record.update(:shopping_basket_record => shopping_basket_record)
    post '/', {}, {'rack.session' => {:user_id => customer.id}}
    assert_equal 'Your discount is pending', flash['error']
    assert last_response.redirect?
    assert_nil shopping_basket_record.reload.discount_record
  end


  def test_redirects_for_used_discount
    discount_record = create :discount_record,
      :start_datetime => DateTime.new(2000),
      :end_datetime => DateTime.new(3000),
      :allocation => 2
    completed_basket_record = create :shopping_basket_record, :discount_record => discount_record
    create :order_record,
      # :customer_record => customer.record,
      :shopping_basket_record => completed_basket_record,
      :state => 'succeded'
    completed_basket_record = create :shopping_basket_record, :discount_record => discount_record
    create :order_record,
      # :customer_record => customer.record,
      :shopping_basket_record => completed_basket_record,
      :state => 'succeded'
    shopping_basket_record = create :shopping_basket_record, :discount_record => discount_record
    shopping_basket = ShoppingBasket.new shopping_basket_record
    create(:purchase_record, :shopping_basket_record => shopping_basket_record)
    customer.record.shopping_basket_record = shopping_basket_record
    customer.record.save
    post '/', {:discount => discount_record.code}, {'rack.session' => {:user_id => customer.id}}
    assert_equal 'This discount code has been used', flash['error']
    assert last_response.redirect?
  end

  def test_stops_on_individual_allocation
    discount_record = create :discount_record,
      :start_datetime => DateTime.new(2000),
      :end_datetime => DateTime.new(3000),
      :customer_allocation => 2
    completed_basket_record = create :shopping_basket_record, :discount_record => discount_record
    create :order_record,
      :customer_record => customer.record,
      :shopping_basket_record => completed_basket_record,
      :state => 'succeded'
    completed_basket_record = create :shopping_basket_record, :discount_record => discount_record
    create :order_record,
      :customer_record => customer.record,
      :shopping_basket_record => completed_basket_record,
      :state => 'succeded'
    shopping_basket_record = create :shopping_basket_record, :discount_record => discount_record
    create(:purchase_record, :shopping_basket_record => shopping_basket_record)
    customer.record.shopping_basket_record = shopping_basket_record
    customer.record.save
    post '/', {:discount => discount_record.code}, {'rack.session' => {:user_id => customer.id}}
    assert_equal 'You have used this discount code', flash['error']
    assert last_response.redirect?

  end

  def test_creates_order
    shopping_basket_record = create :shopping_basket_record
    shopping_basket = ShoppingBasket.new shopping_basket_record
    shopping_basket_record.add_purchase_record create(:purchase_record)
    customer.record.shopping_basket_record = shopping_basket_record
    customer.record.save
    post '/', {}, {'rack.session' => {:user_id => customer.id}}
    order = Orders.last
    assert_equal order.basket_total, shopping_basket.price
    assert_equal order.record.state, 'processing'
    assert last_response.redirect?
    assert_includes last_response.location, 'sandbox'
    # ap last_response.location
  end

  def test_creates_order_with_discount
    discount_record = create :discount_record, :end_datetime => DateTime.new(2016), :start_datetime => DateTime.new(2014)
    shopping_basket_record = create :shopping_basket_record, :discount_record => discount_record
    shopping_basket_record.add_purchase_record create :purchase_record
    customer.record.update(:shopping_basket_record => shopping_basket_record)
    post '/', {}, {'rack.session' => {:user_id => customer.id}}
    order = Orders.last
    # TODO test values
  end

  def test_success_story
    skip
    shopping_basket_record = create :shopping_basket_record
    shopping_basket = ShoppingBasket.new shopping_basket_record
    shopping_basket_record.add_purchase_record create(:purchase_record)
    customer.record.shopping_basket_record = shopping_basket_record
    customer.record.save
    post '/', {}, {'rack.session' => {:user_id => customer.id, 'guest.shopping_basket' => shopping_basket_record.id}}
    order = Orders.last
    get "/#{order.id}/success", {
        "token" => "EC-04S590454J2112151",
      "PayerID" => "BQVSUGQPV47EJ"
    }
    # assert_equal 'succeded', Orders.last.transaction.state
    assert_equal nil, customer.record.reload.shopping_basket_record
    assert_equal nil, last_request.session['guest.shopping_basket']
    # ap last_message.body
  end
end
