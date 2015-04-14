require_relative '../test_config'

class Discount
  class EntityTest < MyRecordTest
    def discount
      @discount ||= Discount.new record
    end

    def record
      @record ||= OpenStruct.new
    end

    def full_price
      Money.new(120)
    end

    def teardown
      @discount = nil
      @record = nil
    end

    def test_can_access_code
      record.code = 'CODE01'
      assert_equal 'CODE01', discount.code
    end

    def test_can_set_code
      discount.code = 'CODE01'
      assert_equal 'CODE01', record.code
    end

    def test_can_access_value
      record.value = Money.new(100)
      assert_equal Money.new(100), discount.value
    end

    def test_can_set_value
      discount.value = Money.new(100)
      assert_equal Money.new(100), record.value
    end

    def test_can_access_allocation
      record.allocation = 100
      assert_equal 100, discount.allocation
    end

    def test_can_set_allocation
      discount.allocation = 100
      assert_equal 100, record.allocation
    end

    def test_can_access_customer_allocation
      record.customer_allocation = 2
      assert_equal 2, discount.customer_allocation
    end

    def test_can_set_customer_allocation
      discount.customer_allocation = 2
      assert_equal 2, record.customer_allocation
    end

    def test_can_access_start_datetime
      record.start_datetime = DateTime.new(2015)
      assert_equal DateTime.new(2015), discount.start_datetime
    end

    def test_can_set_start_datetime
      discount.start_datetime = DateTime.new(2015)
      assert_equal DateTime.new(2015), record.start_datetime
    end

    def test_can_access_end_datetime
      record.end_datetime = DateTime.new(2015)
      assert_equal DateTime.new(2015), discount.end_datetime
    end

    def test_can_set_end_datetime
      discount.end_datetime = DateTime.new(2015)
      assert_equal DateTime.new(2015), record.end_datetime
    end

    def test_can_count_no_redemptions
      @record = Discount::Record.create attributes_for(:discount_record)
      assert_equal 0, discount.number_of_redemptions
    end

    def test_can_count_1_redemption
      @record = Discount::Record.create attributes_for(:discount_record)
      shopping_basket_record = create :shopping_basket_record, :discount_record => record
      order_record = create :order_record, :shopping_basket_record => shopping_basket_record
      order_record.update :state => 'succeded'
      assert_equal 1, discount.number_of_redemptions
    end

    def test_ingnores_not_checked_out
      @record = Discount::Record.create attributes_for(:discount_record)
      create :shopping_basket_record, :discount_record => record
      shopping_basket_record = create :shopping_basket_record, :discount_record => record
      order_record = create :order_record, :shopping_basket_record => shopping_basket_record
      order_record.update :state => 'succeded'
      assert_equal 1, discount.number_of_redemptions
    end
  end
end
