require_relative '../test_config'

class Purchase
  class RecordTest < MyRecordTest
    def test_requires_quantity
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :purchase_record, :quantity => nil
      end
      assert_match(/quantity/, err.message)
    end
  end
end
