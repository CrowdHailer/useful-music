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

    def test_can_access_beginner_level
      record.beginner_level = true
      assert piece.beginner_level?
    end

    def test_can_set_beginner_level
      piece.beginner_level = true
      assert_equal true, record.beginner_level
    end

    def test_can_access_intermediate_level
      record.intermediate_level = true
      assert piece.intermediate_level?
    end

    def test_can_set_intermediate_level
      piece.intermediate_level = true
      assert_equal true, record.intermediate_level
    end

    def test_can_access_advanced_level
      record.advanced_level = true
      assert piece.advanced_level?
    end

    def test_can_set_advanced_level
      piece.advanced_level = true
      assert_equal true, record.advanced_level
    end

    def test_can_access_professional_level
      record.professional_level = true
      assert piece.professional_level?
    end

    def test_can_set_professional_level
      piece.professional_level = true
      assert_equal true, record.professional_level
    end

    def test_can_access_meta_description
      record.meta_description = 'Description'
      assert_equal 'Description', piece.meta_description
    end

    def test_can_set_meta_description
      piece.meta_description = 'Description'
      assert_equal 'Description', record.meta_description
    end

    def test_can_access_meta_keywords
      record.meta_keywords = 'Music players'
      assert_equal 'Music players', piece.meta_keywords
    end

    def test_can_set_meta_keywords
      piece.meta_keywords = 'Music players'
      assert_equal 'Music players', record.meta_keywords
    end
  end
end
