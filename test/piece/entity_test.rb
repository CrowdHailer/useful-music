require_relative '../test_config'

class Piece
  class EntityTest < MyRecordTest
    def piece
      @piece ||= Piece.new record
    end

    def record
      @record ||= OpenStruct.new
    end

    def teardown
      @piece = nil
      @record = nil
    end

    def test_generates_catalogue_number
      record.id = 213
      assert_equal 'UD213', piece.catalogue_number
    end

    def test_returns_nil_catalogue_number
      assert_nil piece.catalogue_number
    end

    ################# Archive #####################

    def test_can_access_title
      record.title = 'Garden Piece'
      assert_equal 'Garden Piece', piece.title
    end

    def test_can_set_title
      piece.title = 'Garden Piece'
      assert_equal 'Garden Piece', record.title
    end

    def test_can_access_sub_heading
      record.sub_heading = 'oboe and keyboard'
      assert_equal 'oboe and keyboard', piece.sub_heading
    end

    def test_can_set_sub_heading
      piece.sub_heading = 'oboe and keyboard'
      assert_equal 'oboe and keyboard', record.sub_heading
    end

    def test_can_access_description
      record.description = 'Lots of interesting information'
      assert_equal 'Lots of interesting information', piece.description
    end

    def test_can_set_description
      piece.description = 'Lots of interesting information'
      assert_equal 'Lots of interesting information', record.description
    end

    def test_can_access_category
      record.category = 'Duet'
      assert_equal 'Duet', piece.category
    end

    def test_can_set_category
      piece.category = 'Duet'
      assert_equal 'Duet', record.category
    end

    def test_can_access_notation_preview
      record.notation_preview = :file
      assert_equal :file, piece.notation_preview
    end

    def test_can_set_notation_preview
      piece.notation_preview = :file
      assert_equal :file, record.notation_preview
    end

    def test_can_access_audio_preview
      record.audio_preview = :file
      assert_equal :file, piece.audio_preview
    end

    def test_can_set_audio_preview
      piece.audio_preview = :file
      assert_equal :file, record.audio_preview
    end

    def test_can_access_cover_image
      record.cover_image = :file
      assert_equal :file, piece.cover_image
    end

    def test_can_set_cover_image
      piece.cover_image = :file
      assert_equal :file, record.cover_image
    end
  end
end
