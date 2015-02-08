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
    record = create :piece_record
    ap record.notation_preview.url
    get "/#{record.catalogue_number}"
    ap 's'
    assert_includes 's', last_response.body
  end
end
