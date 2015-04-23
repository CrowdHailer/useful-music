require_relative '../test_config'

class PurchaseTest < MyRecordTest
  def record
    @record ||= OpenStruct.new
  end

  def purchase
    @purchase ||= Purchase.new record
  end

  def teardown
    @purchase = nil
    @record = nil
  end

  ################# Associations #####################

  def test_has_item
    @record = create :purchase_record
    assert_equal Item, purchase.item.class
  end

  def test_does_not_have_item_if_no_item_record
    assert_nil purchase.item
  end

  def test_can_set_item
    item = Item.new(create :item_record)
    @record = create :purchase_record
    purchase.item = item
    assert_equal item, purchase.item
  end

  def test_sets_nil_if_setting_nil_item
    @record = create :purchase_record
    purchase.item = nil
    assert_nil record.item_record
  end

  def test_has_shopping_basket
    @record = create :purchase_record
    assert_equal ShoppingBasket, purchase.shopping_basket.class
  end

  def test_does_not_have_shopping_basket_if_no_shopping_basket_record
    assert_nil purchase.shopping_basket
  end

  def test_can_set_shopping_basket
    shopping_basket = ShoppingBasket.new(create :shopping_basket_record)
    @record = create :purchase_record
    purchase.shopping_basket = shopping_basket
    assert_equal shopping_basket, purchase.shopping_basket
  end

  def test_sets_nil_if_setting_nil_shopping_basket
    @record = create :purchase_record
    purchase.shopping_basket = nil
    assert_nil record.shopping_basket_record
  end

  ################# Archive #####################

  def test_can_access_quantity
    record.quantity = 5
    assert_equal 5, purchase.quantity
  end

  def test_can_set_quantity
    purchase.quantity = 5
    assert_equal 5, record.quantity
  end

  def test_can_access_created_at
    record.created_at = 5
    assert_equal 5, purchase.created_at
  end

  def test_can_access_updated_at
    record.updated_at = 5
    assert_equal 5, purchase.updated_at
  end

end
