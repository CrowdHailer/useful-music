require_relative '../test_config'

class CatalogueTest < MyRecordTest
  def test_returns_all_records
    beginner = Piece.new(create :piece_record, :beginner)
    intermediate = Piece.new(create :piece_record, :intermediate)
    assert_includes Catalogue.all, beginner
  end
end
