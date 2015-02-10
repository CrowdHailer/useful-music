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
      piece = Piece.new OpenStruct.new(:id => 213)
      assert_equal 'UD213', piece.catalogue_number
    end

    def test_returns_nil_catalogue_number
      piece = Piece.new OpenStruct.new(:id => nil)
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
  end
end
