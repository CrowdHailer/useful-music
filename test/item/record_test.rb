require_relative '../test_config'

class Item
  class RecordTest < MyRecordTest
    def test_requires_name
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :item_record, :name => nil
      end
      assert_match(/name/, err.message)
    end
  end
end
