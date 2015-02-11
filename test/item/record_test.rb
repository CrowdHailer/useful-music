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

    def test_can_save_asset
      record = create :item_record
      assert record.asset.path
    end

    def test_requires_asset
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :item_record, :asset => nil
      end
      assert_match(/asset/, err.message)
    end

    def test_renames_asset_file
      record = create :item_record, :name => 'piano solo'
      piece_id = record.piece_record.id
      assert_match /pieces\/UD#{piece_id}\/items\/UD#{piece_id}_piano_solo\.mp3$/, record.asset.path
    end
  end
end
