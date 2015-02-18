require_relative '../test_config'

class AboutControllerTest < MiniTest::Test
  include ControllerTesting

  def app
    AboutController
  end

  def test_index_page_is_available
    assert_ok get '/'
  end

end
