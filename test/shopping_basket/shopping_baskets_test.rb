require_relative '../test_config'

class ShoppingBasketsTest < MyRecordTest
  def test_can_save_basket_without_order
    shopping_basket = ShoppingBaskets.create
    assert_silent do
      ShoppingBaskets.save shopping_basket
    end
  end

  def test_raises_error_when_saving_basket_with_completed_order
    shopping_basket = ShoppingBaskets.create
    order_record = create :order_record,
      :state => 'succeded',
      :shopping_basket_record => shopping_basket.record
    assert_raises ShoppingBasket::AlreadyCheckedOut do
      ShoppingBaskets.save shopping_basket
    end
  end

  def test_does_not_raise_error_for_pending_orders
    shopping_basket = ShoppingBaskets.create
    order_record = create :order_record,
      :state => 'pending',
      :shopping_basket_record => shopping_basket.record
    assert_silent do
      ShoppingBaskets.save shopping_basket
    end
  end
end
