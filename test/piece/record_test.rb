require_relative '../test_config'

class Piece
  class RecordTest < MyRecordTest
    # Associations

    def test_can_have_multiple_items
      record = create :piece_record
      2.times { record.add_item_record create(:item_record) }
      assert_equal 2, record.item_records.count
    end

    # Storage
    def test_requires_catalogue_number
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :piece_record, :id => nil
      end
      assert_match(/id/, err.message)
    end

    def test_catalogue_number_must_be_unique
      err = assert_raises Sequel::UniqueConstraintViolation do
        create :piece_record, :id => 20
        create :piece_record, :id => 20
      end
      assert_match(/id/, err.message)
    end

    def test_requires_title
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :piece_record, :title => nil
      end
      assert_match(/title/, err.message)
    end

    def test_requires_sub_heading
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :piece_record, :sub_heading => nil
      end
      assert_match(/sub_heading/, err.message)
    end

    def test_requires_description
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :piece_record, :description => nil
      end
      assert_match(/description/, err.message)
    end

    def test_requires_category
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :piece_record, :category => nil
      end
      assert_match(/category/, err.message)
    end

    def test_can_be_beginner_level
      record = create :piece_record, :beginner
      assert record.beginner_level
    end

    def test_can_be_intermediate_level
      record = create :piece_record, :intermediate
      assert record.intermediate_level
    end

    def test_can_be_advanced_level
      record = create :piece_record, :advanced
      assert record.advanced_level
    end

    def test_can_be_professional_level
      record = create :piece_record, :professional
      assert record.professional_level
    end

    def test_can_save_notation_preview
      record = create :piece_record
      assert record.notation_preview.path
    end

    def test_requires_notation_preview
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :piece_record, :notation_preview => nil
      end
      assert_match(/notation_preview/, err.message)
    end

    def test_can_save_audio_preview
      record = create :piece_record
      assert record.audio_preview.path
    end

    def test_can_save_cover_image
      record = create :piece_record
      assert record.cover_image.path
    end

    def test_requires_cover_image
      err = assert_raises Sequel::NotNullConstraintViolation do
        r = create :piece_record, :cover_image => nil
      end
      assert_match(/cover_image/, err.message)
    end

    def test_can_have_meta_description
      record = create :piece_record, :meta_data
      assert record.meta_description
    end

    def test_can_have_meta_keywords
      record = create :piece_record, :meta_data
      assert record.meta_keywords
    end

  end
end
