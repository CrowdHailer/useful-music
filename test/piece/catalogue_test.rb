require_relative '../test_config'

class CatalogueTest < MyRecordTest
  def test_is_empty
    assert Catalogue.empty?
  end

  # def test_is_not_empty
  #   create :piece_record
  #   refute Catalogue.empty?
  # end
  #
  # def test_delegates_count_to_record
  #   assert_equal 0, Catalogue.count
  #   create :piece_record
  #   assert_equal 1, Catalogue.count
  # end
  #
  # def test_returns_all_records
  #   beginner = Piece.new(create :piece_record, :beginner)
  #   intermediate = Piece.new(create :piece_record, :intermediate)
  #   assert_includes Catalogue.all, beginner
  # end
  #
  # def test_get_first_default_by_id
  #   a = Piece.new(create :piece_record, :id => 120)
  #   c = Piece.new(create :piece_record, :id => 140)
  #   b = Piece.new(create :piece_record, :id => 100)
  #   assert_equal b, Catalogue.first
  # end
  #
  # def test_first_returns_nil_if_no_items
  #   assert_nil Catalogue.first
  # end
  #
  # def test_get_first_ordered_by_title
  #   a = Piece.new(create :piece_record, :id => 100, :title => 'b')
  #   c = Piece.new(create :piece_record, :id => 120, :title => 'c')
  #   b = Piece.new(create :piece_record, :id => 140, :title => 'a')
  #   assert_equal b.id, Catalogue.first(:order => 'title').id
  # end
  #
  # def test_get_last_default_by_id
  #   a = Piece.new(create :piece_record, :id => 120)
  #   c = Piece.new(create :piece_record, :id => 140)
  #   b = Piece.new(create :piece_record, :id => 100)
  #   assert_equal c, Catalogue.last
  # end
  #
  # def test_last_returns_nil_if_no_items
  #   assert_nil Catalogue.last
  # end
  #
  # def test_find_by_id
  #   piece = Piece.new(create :piece_record, :id => 120)
  #   assert_equal piece, Catalogue['120']
  # end
  #
  # def test_find_by_catalogue_number
  #   piece = Piece.new(create :piece_record, :id => 120)
  #   assert_equal piece, Catalogue['UD120']
  # end
  #
  # def test_find_returns_nil_if_no_items
  #   assert_nil Catalogue['UD101']
  # end
  #
  # def test_returns_all_beginner_pieces
  #   beginner = Piece.new(create :piece_record, :beginner)
  #   intermediate = Piece.new(create :piece_record, :intermediate)
  #   advanced = Piece.new(create :piece_record, :advanced)
  #   assert_includes Catalogue.all(:levels => [:beginner]), beginner
  #   assert_includes Catalogue.all(:levels => [:beginner, :intermediate]), intermediate
  #   refute_includes Catalogue.all(:levels => [:beginner, :intermediate]), advanced
  #   refute_includes Catalogue.all(:levels => [:beginner]), advanced
  # end
  #
  # def test_level_method
  #   beginner = Piece.new(create :piece_record, :beginner)
  #   intermediate = Piece.new(create :piece_record, :intermediate)
  #   advanced = Piece.new(create :piece_record, :advanced)
  #   assert_includes Catalogue.levels(:beginner), beginner
  #   assert_includes Catalogue.levels(:beginner, :intermediate), intermediate
  #   refute_includes Catalogue.levels(:beginner, :intermediate), advanced
  #   refute_includes Catalogue.levels(:beginner), advanced
  # end
  #
  # def test_returns_all_solo_pieces
  #   solo = Piece.new(create :piece_record, :solo)
  #   duet = Piece.new(create :piece_record, :duet)
  #   trio = Piece.new(create :piece_record, :trio)
  #   assert_includes Catalogue.all(:categories => [:solo]), solo
  #   assert_includes Catalogue.all(:categories => [:solo, :duet]), duet
  #   refute_includes Catalogue.all(:categories => [:solo, :duet]), trio
  #   refute_includes Catalogue.all(:categories => [:solo]), trio
  # end
  #
  # def test_returns_all_piano_pieces
  #   piano = Piece.new(create :piece_record, :piano)
  #   recorder = Piece.new(create :piece_record, :recorder)
  #   flute = Piece.new(create :piece_record, :flute)
  #   assert_includes Catalogue.all(:instruments => [:piano]), piano
  #   assert_includes Catalogue.all(:instruments => [:piano, :recorder]), recorder
  #   refute_includes Catalogue.all(:instruments => [:piano, :recorder]), flute
  #   refute_includes Catalogue.all(:instruments => [:piano]), flute
  # end
  #
  # def test_returns_all_with_givern_title
  #   a = Piece.new(create :piece_record, :title => 'A Good tune')
  #   a = Piece.new(create :piece_record, :title => 'A Good tune')
  #   b = Piece.new(create :piece_record, :title => 'A Bad tune')
  #   assert_equal 2, Catalogue.all(:title => 'A Good tune').count
  # end
  #
  # def test_counts_those_with_title
  #   a = Piece.new(create :piece_record, :title => 'A Good tune')
  #   a = Piece.new(create :piece_record, :title => 'A Good tune')
  #   b = Piece.new(create :piece_record, :title => 'A Bad tune')
  #   assert_equal 2, Catalogue.count(:title => 'A Good tune')
  # end
  #
  # def test_empty_if_matches_no_title
  #   b = Piece.new(create :piece_record, :title => 'A Bad tune')
  #   assert Catalogue.empty?(:title => 'A Good tune')
  # end
  #
  # def test_page_shows_first_results
  #   10.times do |i|
  #     create :piece_record, :id => (100 + i)
  #   end
  #   page = Catalogue.page(:page_size => 3, :page => 2)
  #   assert_equal 103, page.first.id
  #   assert_equal 3, page.page_size
  #   assert_equal 4, page.page_count
  #   assert_equal 2, page.current_page
  # end
end
