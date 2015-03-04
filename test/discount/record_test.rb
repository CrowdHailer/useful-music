require_relative '../test_config'

class Discount
  class RecordTest < MyRecordTest
    def test_has_an_id
      record = create :discount_record
      # Checks id has non negligable length
      assert_match(/.{8}/, record.id)
    end

    def test_has_money_value
      record = create :discount_record, :value => Money.new(500)
      assert_equal Money.new(500, 'gbp'), record.value
    end

    def test_requires_value
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :discount_record, :value => nil
      end
      assert_match(/value/, err.message)
    end

    def test_requires_value_greater_than_zero
      err = assert_raises Sequel::CheckConstraintViolation do
        create :discount_record, :value => Money.new(0)
      end
      assert_match(/value/, err.message)
    end

    def test_requires_value_less_than_1000_gbp
      err = assert_raises Sequel::CheckConstraintViolation do
        create :discount_record, :value => Money.new(100000)
      end
      assert_match(/value/, err.message)
    end

    def test_has_allocation
      record = create :discount_record, :allocation => 500
      assert_equal 500, record.allocation
    end

    def test_requires_allocation
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :discount_record, :allocation => nil
      end
      assert_match(/allocation/, err.message)
    end

    def test_requires_allocation_greater_than_zero
      err = assert_raises Sequel::CheckConstraintViolation do
        create :discount_record, :allocation => 0
      end
      assert_match(/allocation/, err.message)
    end

    def test_requires_allocation_less_than_a_million
      err = assert_raises Sequel::CheckConstraintViolation do
        create :discount_record, :allocation => 1000000
      end
      assert_match(/allocation/, err.message)
    end

    def test_has_customer_allocation
      record = create :discount_record, :customer_allocation => 1
      assert_equal 1, record.customer_allocation
    end

    def test_requires_customer_allocation
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :discount_record, :customer_allocation => nil
      end
      assert_match(/customer_allocation/, err.message)
    end

    def test_requires_customer_allocation_greater_than_zero
      err = assert_raises Sequel::CheckConstraintViolation do
        create :discount_record, :customer_allocation => 0
      end
      assert_match(/customer_allocation/, err.message)
    end

    def test_requires_customer_allocation_less_than_a_million
      err = assert_raises Sequel::CheckConstraintViolation do
        create :discount_record, :customer_allocation => 1000000
      end
      assert_match(/customer_allocation/, err.message)
    end

    def test_requires_start_datetime
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :discount_record, :start_datetime => nil
      end
      assert_match(/start_datetime/, err.message)
    end

    def test_requires_end_datetime
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :discount_record, :end_datetime => nil
      end
      assert_match(/end_datetime/, err.message)
    end
  end
end
