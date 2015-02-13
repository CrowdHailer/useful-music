require_relative '../test_config'

class PurchaseTest < MyRecordTest
  def record
    @record ||= OpenStruct.new
  end

  def purchase
    @purchase = Purchase.new record
  end

  def single_price_item
    OpenStruct.new :initial_price => Money.new(50)
  end

  def discount_price_item
    OpenStruct.new :initial_price => Money.new(50), :subsequent_price => Money.new(25)
  end

  def teardown
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
    assert_equal item.record, purchase.record.item_record
  end

  def test_delegates_item_getter_to_cartridge
    skip
  end

  def test_calculates_price_of_single_single_price_item
    skip
    record.item_record = single_price_item
    record.quantity = 1
    purchase = Purchase.new record
    assert_equal Money.new(50, 'gbp'), purchase.price
  end

  def test_calculates_price_of_several_single_price_items
    skip
    record.item_record = single_price_item
    record.quantity = 3
    purchase = Purchase.new record
    assert_equal Money.new(150, 'gbp'), purchase.price
  end

  def test_calculates_discount_on_subsequent_pricing
    skip
    record.item_record = discount_price_item
    record.quantity = 3
    purchase = Purchase.new record
    assert_equal Money.new(100, 'gbp'), purchase.price
  end
end
