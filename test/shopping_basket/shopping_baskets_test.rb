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

  def test_fetching_inactive_shopping_baskets
    old_basket = ShoppingBasket.new create(:shopping_basket_record)
    old_basket.record.update :created_at => DateTime.now - 2
    old_basket.record.refresh

    guest_basket = ShoppingBasket.new create(:shopping_basket_record)

    customer_basket = ShoppingBasket.new create(:shopping_basket_record)
    customer = Customer.new create(:customer_record,
      :shopping_basket_record => customer_basket.record
    )

    checked_out_basket = ShoppingBasket.new create(:shopping_basket_record)
    order = create :order_record,
      :shopping_basket_record => checked_out_basket.record


    inactive_baskets = ShoppingBaskets.inactive
    assert_includes inactive_baskets, guest_basket
    assert_includes inactive_baskets, old_basket
    assert_equal 2, inactive_baskets.count

    yesterday = Date.yesterday
    old_inactive_baskets = ShoppingBaskets.inactive(:since => (yesterday))
    refute_includes old_inactive_baskets, guest_basket
    assert_includes old_inactive_baskets, old_basket
    assert_equal 1, old_inactive_baskets.count

  end

  def test_clearing_inactive_shopping_baskets
    old_basket = ShoppingBasket.new create(:shopping_basket_record)
    old_basket.record.update :created_at => DateTime.now - 2
    old_basket.record.refresh

    guest_basket = ShoppingBasket.new create(:shopping_basket_record)

    customer_basket = ShoppingBasket.new create(:shopping_basket_record)
    customer = Customer.new create(:customer_record,
      :shopping_basket_record => customer_basket.record
    )

    checked_out_basket = ShoppingBasket.new create(:shopping_basket_record)
    order = create :order_record,
      :shopping_basket_record => checked_out_basket.record


    yesterday = Date.yesterday
    ShoppingBaskets.clear_inactive(:since => (yesterday))
    remaining = ShoppingBaskets.all
    assert_includes remaining, guest_basket
    refute_includes remaining, old_basket
    assert_equal 3, remaining.count

  end
end
