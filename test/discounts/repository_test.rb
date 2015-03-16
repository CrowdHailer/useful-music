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

  def test_fetches_available_discounts
    discount = create :discount_record,
      :start_datetime => DateTime.new(2015, 1, 1),
      :end_datetime => DateTime.new(2015, 1, 3)
    DateTime.stub :now, DateTime.new(2015, 1, 2) do
      assert_equal discount, Discounts.available(discount.code).record
    end
  end

  def test_doesnt_fetch_finished_discount
    create :discount_record,
      :code => 'other',
      :start_datetime => DateTime.new(2015, 1, 1),
      :end_datetime => DateTime.new(2015, 1, 5)
    discount = create :discount_record,
      :start_datetime => DateTime.new(2015, 1, 1),
      :end_datetime => DateTime.new(2015, 1, 3)
    DateTime.stub :now, DateTime.new(2015, 1, 4) do
      assert_equal nil, Discounts.available(discount.code)
    end
  end

  def test_doesnt_fetch_yet_to_start_discount
    create :discount_record,
      :code => 'other',
      :start_datetime => DateTime.new(2015, 1, 1),
      :end_datetime => DateTime.new(2015, 1, 5)
    discount = create :discount_record,
      :start_datetime => DateTime.new(2015, 1, 5),
      :end_datetime => DateTime.new(2015, 1, 6)
    DateTime.stub :now, DateTime.new(2015, 1, 4) do
      assert_equal nil, Discounts.available(discount.code)
    end
  end
    # during = create :discount_record, :start_datetime => DateTime.new(2015, 2, 1)
    # after = create :discount_record, :start_datetime => DateTime.new(2015, 3, 1)
end
