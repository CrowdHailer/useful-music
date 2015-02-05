require_relative '../test_config'

class HomeControllerTest < MiniTest::Test
  include ControllerTesting

  def app
    HomeController
  end

  def test_home_page_is_available
    get '/'
    assert_ok
  end
end
