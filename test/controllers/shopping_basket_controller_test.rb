require_relative '../test_config'

class ShoppingBasketsControllerTest < MyRecordTest
  include ControllerTesting

  def app
    ShoppingBasketsController
  end

  def test_redirects_when_basket_not_found_to_show
    get '/1'
    assert last_response.redirect?
  end

  def test_shows_shopping_basket_to_guest
    shopping_basket_record = create :shopping_basket_record
    assert_ok get("/#{shopping_basket_record.id}")
  end

  def test_shows_shopping_basket_to_customer
    shopping_basket_record = create :shopping_basket_record
    assert_ok get("/#{shopping_basket_record.id}", {}, {'rack.session' => {:user_id => customer.id}})
  end

  def test_can_update_basket_with_discount_code
    discount_record = create :discount_record,
      :start_datetime => DateTime.new(2014),
      :end_datetime => DateTime.new(2017)
    shopping_basket_record = create :shopping_basket_record
    patch "/#{shopping_basket_record.id}", {:shopping_basket => {:discount => discount_record.code}}
    assert_equal discount_record, shopping_basket_record.reload.discount_record
    assert_equal 'Discount Code Added', flash['success']
    assert last_response.redirect?
  end

  def test_can_remove_discount_code
    discount_record = create :discount_record,
      :start_datetime => DateTime.new(2014),
      :end_datetime => DateTime.new(2017)
    shopping_basket_record = create :shopping_basket_record, :discount_record => discount_record
    patch "/#{shopping_basket_record.id}", {:shopping_basket => {:discount => ''}}
    assert_nil shopping_basket_record.reload.discount_record
    assert_equal 'Discount Code Removed', flash['success']
    assert last_response.redirect?
  end

  def test_cant_update_basket_with_non_existant_discount_code
    shopping_basket_record = create :shopping_basket_record
    patch "/#{shopping_basket_record.id}", {:shopping_basket => {:discount => 'WRONG'}}
    assert_equal 'Discount Code Invalid', flash['error']
    assert last_response.redirect?
  end

  def test_cant_use_expired_discount_code
    discount_record = create :discount_record, :end_datetime => DateTime.new(2014)
    shopping_basket_record = create :shopping_basket_record
    patch "/#{shopping_basket_record.id}", {:shopping_basket => {:discount => discount_record.code}}
    assert_equal 'Discount Code Currently Unavailable', flash['error']
    assert last_response.redirect?
  end

  def test_cant_use_pending_discount_code
    discount_record = create :discount_record, :start_datetime => DateTime.new(2017)
    shopping_basket_record = create :shopping_basket_record
    patch "/#{shopping_basket_record.id}", {:shopping_basket => {:discount => discount_record.code}}
    assert_equal 'Discount Code Currently Unavailable', flash['error']
    assert last_response.redirect?
  end

  def test_redirect_when_editing_non_existant_basket
    patch "/1", {:shopping_basket => {:discount => 3}}
    assert last_response.redirect?
  end

  def test_can_destroy_guest_shopping_basket
    shopping_basket_record = create :shopping_basket_record
    delete "/#{shopping_basket_record.id}"
    assert_equal 'Shopping basket cleared', flash['success']
    assert last_response.redirect?
  end

  def test_can_destroy_customer_shopping_basket
    shopping_basket_record = create :shopping_basket_record
    customer.record.update(:shopping_basket_record => shopping_basket_record)
    delete "/#{shopping_basket_record.id}", {}, {'rack.session' => {:user_id => customer.id}}
  end

  def test_redirects_if_basket_not_found_to_delete
    delete "/1", {}, {'rack.session' => {:user_id => customer.id}}
    assert last_response.redirect?
  end
end
