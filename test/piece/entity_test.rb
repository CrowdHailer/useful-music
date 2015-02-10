require_relative '../test_config'

class PieceTest < MiniTest::Test
  def test_generates_catalogue_number
    piece = Piece.new OpenStruct.new(:id => 213)
    assert_equal 'UD213', piece.catalogue_number
  end

  def test_returns_nil_catalogue_number
    piece = Piece.new OpenStruct.new(:id => nil)
    assert_nil piece.catalogue_number
  end
end
