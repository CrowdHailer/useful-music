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

  def test_new_page_is_available
    skip
    assert_ok get '/new'
  end

  def test_can_create_piece
    skip
    post '/', :piece => attributes_for(:piece_record)
    assert Piece::Record.last
  end

  def test_show_page_is_available
    skip
    record = create :piece_record, :catalogue_number => 123
    get "/#{record.catalogue_number}"
    assert_includes last_response.body, 'UD123'
    end

  def test_destroy_action_redirects_to_index
    skip
    record = create :piece_record
    delete "/#{record.catalogue_number}"
    assert_equal '/', last_response.location
  end
end
