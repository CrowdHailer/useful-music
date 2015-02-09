require_relative '../test_config'

class Purchase
  class RecordTest < MyRecordTest
    def test_requires_quantity
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :purchase_record, :quantity => nil
      end
      assert_match(/quantity/, err.message)
    end

    def test_can_have_item
      purchase_record = create :purchase_record
      assert purchase_record.item_record
    end

    def test_requires_item
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :purchase_record, :item_record => nil
      end
      assert_match(/item_id/, err.message)
    end
  end
end
