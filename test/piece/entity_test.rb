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
  end
end
