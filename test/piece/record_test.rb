require_relative '../test_config'

class Piece
  class RecordTest < MyRecordTest
    def values

    end
    def test_can_save_a_catalogue_number
      assert_silent do
        skip
        r = Record.new :catalogue_number => 'UD001'
        r.save
      end
    end

    def test_requires_catalogue_number
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :piece_record, :catalogue_number => nil
      end
      assert_match(/catalogue_number/, err.message)
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

    def test_requires_notation_preview
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :piece_record, :notation_preview => nil
      end
      assert_match(/notation_preview/, err.message)
    end

    def test_requires_cover_image
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :piece_record, :cover_image => nil
      end
      assert_match(/cover_image/, err.message)
    end
  end
end
