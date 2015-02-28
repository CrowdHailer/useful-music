require_relative '../test_config'

class CatalogueTest < MyRecordTest
  def test_is_empty
    assert Catalogue.empty?
  end

  def test_is_not_empty
    create :piece_record
    refute Catalogue.empty?
  end

  def test_delegates_count_to_record
    assert_equal 0, Catalogue.count
    create :piece_record
    assert_equal 1, Catalogue.count
  end

  def test_returns_all_records
    beginner = Piece.new(create :piece_record, :beginner)
    intermediate = Piece.new(create :piece_record, :intermediate)
    assert_includes Catalogue.all, beginner
  end

  def test_get_first_default_by_id
    a = Piece.new(create :piece_record, :id => 120)
    c = Piece.new(create :piece_record, :id => 140)
    b = Piece.new(create :piece_record, :id => 100)
    assert_equal b, Catalogue.first
  end

  def test_first_returns_nil_if_no_items
    assert_nil Catalogue.first
  end

  def test_get_last_default_by_id
    a = Piece.new(create :piece_record, :id => 120)
    c = Piece.new(create :piece_record, :id => 140)
    b = Piece.new(create :piece_record, :id => 100)
    assert_equal c, Catalogue.last
  end

  def test_last_returns_nil_if_no_items
    assert_nil Catalogue.last
  end

  def test_find_by_id
    piece = Piece.new(create :piece_record, :id => 120)
    assert_equal piece, Catalogue['UD120']
  end

  def test_find_returns_nil_if_no_items
    assert_nil Catalogue['UD101']
  end
end
