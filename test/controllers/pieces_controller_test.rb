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
    assert_ok get '/new'
  end

  def test_can_create_piece
    post '/', :piece => attributes_for(:piece_record, :id => 212)
    assert_equal 212, Piece::Record.last.id
    assert_equal '/UD212', last_response.location
  end

  def test_show_page_is_available
    record = create :piece_record, :id => 123
    assert_ok get "/UD#{record.id}"
    assert_includes last_response.body, 'UD123'
    end

  def test_destroy_action_redirects_to_index
    skip
    record = create :piece_record
    delete "/#{record.catalogue_number}"
    assert_equal '/', last_response.location
  end
end
