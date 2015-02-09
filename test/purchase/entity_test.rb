require_relative '../test_config'

class PurchaseTest < MiniTest::Test
  def record
    @record ||= OpenStruct.new
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

  def test_delegates_item_getter_to_cartridge

    ap record
  end
  def test_calculates_price_of_single_single_price_item
    record.item_record = single_price_item
    record.quantity = 1
    purchase = Purchase.new record
    assert_equal Money.new(50, 'gbp'), purchase.price
  end

  def test_calculates_price_of_several_single_price_items
    record.item_record = single_price_item
    record.quantity = 3
    purchase = Purchase.new record
    assert_equal Money.new(150, 'gbp'), purchase.price
  end

  def test_calculates_discount_on_subsequent_pricing
    record.item_record = discount_price_item
    record.quantity = 3
    purchase = Purchase.new record
    assert_equal Money.new(100, 'gbp'), purchase.price
  end
end
