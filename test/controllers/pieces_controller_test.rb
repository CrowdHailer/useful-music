require_relative '../test_config'

class PiecesControllerTest < MiniTest::Test
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
end
