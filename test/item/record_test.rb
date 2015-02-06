require_relative '../test_config'

class Item
  class RecordTest < MyRecordTest
    def test_requires_name
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :item_record, :name => nil
      end
      assert_match(/name/, err.message)
    end

    def test_requires_initial_price
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :item_record, :initial_price => nil
      end
      assert_match(/initial_price/, err.message)
    end

    def test_does_not_require_subsequent_price
      assert_silent do
        create :item_record, :subsequent_price => nil
      end
    end

    def test_requires_asset
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :item_record, :asset => nil
      end
      assert_match(/asset/, err.message)
    end
  end
end
