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
  end
end
