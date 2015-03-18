require_relative '../test_config'

class PiecesControllerTest < MyRecordTest
  include ControllerTesting

  def app
    PiecesController
  end

  def test_index_page_is_available
    create :piece_record, :id => 100
    assert_ok get '/'
    assert_includes last_response.body, 'UD100'
  end

  def test_search_redirects_to_show_page
    create :piece_record, :id => 100
    get '/search', {:search => '100'}
    assert last_response.redirect?
    assert_equal '/pieces/UD100', last_response.location
  end

  def test_searchs_on_text_if_no_piece
    create :piece_record, :title => 'test piece'
    get '/search', {:search => 'test'}
    # assert_equal 'Could not find piece requested', flash['error']
    # assert last_response.redirect?
    assert_equal '/pieces?catalogue_search[title_like]=test', last_response.location
  end

  def test_show_page_is_available
    record = create :piece_record, :id => 123
    record.add_item_record create :item_record
    assert_ok get "/UD#{record.id}"
    assert_includes last_response.body, 'UD123'
  end

  def test_show_page_is_available_without_cover_image_or_audio_preview
    record = create :piece_record, :id => 123, :cover_image => nil, :audio_preview => nil
    assert_ok get "/UD#{record.id}"
    assert_includes last_response.body, 'UD123'
  end

  def test_from_show_page_redirected_if_no_piece
    get "/UD000"
    assert_equal 'Piece not found', flash['error']
    assert last_response.redirect?
  end

end
