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

    def test_can_be_beginner
      record = create :piece_record, :beginner
      assert record.beginner
    end

    def test_can_be_intermediate
      record = create :piece_record, :intermediate
      assert record.intermediate
    end

    def test_can_be_advanced
      record = create :piece_record, :advanced
      assert record.advanced
    end

    def test_can_be_professional
      record = create :piece_record, :professional
      assert record.professional
    end

    def test_can_be_for_piano
      record = create :piece_record, :piano => true
      assert record.piano
    end

    def test_can_be_for_recorder
      record = create :piece_record, :recorder => true
      assert record.recorder
    end

    def test_can_be_for_flute
      record = create :piece_record, :flute => true
      assert record.flute
    end

    def test_can_be_for_oboe
      record = create :piece_record, :oboe => true
      assert record.oboe
    end

    def test_can_be_for_clarineo
      record = create :piece_record, :clarineo => true
      assert record.clarineo
    end

    def test_can_be_for_clarinet
      record = create :piece_record, :clarinet => true
      assert record.clarinet
    end

    def test_can_be_for_basson
      record = create :piece_record, :basson => true
      assert record.basson
    end

    def test_can_be_for_saxophone
      record = create :piece_record, :saxophone => true
      assert record.saxophone
    end

    def test_can_be_for_trumpet
      record = create :piece_record, :trumpet => true
      assert record.trumpet
    end

    def test_can_be_for_violin
      record = create :piece_record, :violin => true
      assert record.violin
    end

    def test_can_be_for_viola
      record = create :piece_record, :viola => true
      assert record.viola
    end

    def test_can_be_for_percussion
      record = create :piece_record, :percussion => true
      assert record.percussion
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

    def test_renames_notation_preview_file
      record = create :piece_record, :id => 101
      assert_match /pieces\/UD101\/UD101_notation_preview\.pdf$/, record.notation_preview.path
    end

    def test_can_save_audio_preview
      record = create :piece_record
      assert record.audio_preview.path
    end

    def test_renames_audio_preview_file
      record = create :piece_record, :id => 101
      assert_match /pieces\/UD101\/UD101_audio_preview\.mp3$/, record.audio_preview.path
    end

    def test_can_save_cover_image
      record = create :piece_record
      assert record.cover_image.path
    end

    def test_renames_cover_image_file
      record = create :piece_record, :id => 101
      assert_match /pieces\/UD101\/UD101_cover_image\.jpg$/, record.cover_image.path
    end

    def test_requires_cover_image
      err = assert_raises Sequel::NotNullConstraintViolation do
        r = create :piece_record, :cover_image => nil
      end
      assert_match(/cover_image/, err.message)
    end

    def test_can_have_print_version
      record = create :piece_record, :print_version => 'sdb'
      assert record.print_version
    end

    def test_can_have_weezic_version
      record = create :piece_record, :weezic_version => 'dfsd'
      assert record.weezic_version
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
