require_relative '../test_config'

class ShoppingBasketsControllerTest < MyRecordTest
  include ControllerTesting

  def app
    ShoppingBasketsController
  end

  def test_redirects_when_basket_not_found
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
end
