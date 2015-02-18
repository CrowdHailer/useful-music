require_relative '../test_config'

class Order
  class RecordTest < MyRecordTest
    def test_requires_customer_record
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :order_record, :customer_record => nil
      end
      assert_match(/customer_id/, err.message)
    end

    def test_requires_shopping_basket_record
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :order_record, :shopping_basket_record => nil
      end
      assert_match(/shopping_basket_id/, err.message)
    end

    def test_has_an_id
      record = create :order_record
      # Checks id has non negligable length
      assert_match(/.{8}/, record.id)
    end
  end
end
