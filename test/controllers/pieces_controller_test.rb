require_relative '../test_config'

class PiecesControllerTest < MyRecordTest
  include ControllerTesting

  def app
    PiecesController
  end

  def test_home_page_is_available
    assert_ok get '/'
  end

  def test_new_page_is_available
    assert_ok get '/new'
  end

  def test_can_create_piece
    post '/', :piece => attributes_for(:piece_record)
    assert Piece::Record.last
  end

  def test_show_page_is_available
    record = create :piece_record, :catalogue_number => 123
    get "/#{record.catalogue_number}"
    assert_includes last_response.body, 'UD123'
  end

  def test_destroy_action_redirects_to_index
    record = create :piece_record
    delete "/#{record.catalogue_number}"
    assert_equal '/', last_response.location 
  end
end
