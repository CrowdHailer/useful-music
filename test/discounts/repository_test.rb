require_relative '../test_config'

class DiscountsTest < MyRecordTest
  def test_can_build_discount
    discount = Discounts.build :code => 'MAX121'
    assert_equal 'MAX121', discount.code
  end

  def test_can_create_discount
    discount = Discounts.create attributes_for(:discount_record, :code => 'NEW12')
    assert_equal 'NEW12', discount.code
  end

  def test_can_save_discount
    discount = Discounts.build attributes_for(:discount_record, :code => 'NEW12')
    assert_empty Discounts
    assert_equal Discounts, Discounts.save(discount)
    refute_empty Discounts
  end
end
