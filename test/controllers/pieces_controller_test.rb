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

  # def test_can_create_piece
  #   assert_empty Piece::Record
  #   post '/', :piece => FactoryGirl.attributes_for(:piece_record)
  #   assert Piece::Record.last
  # end
end
