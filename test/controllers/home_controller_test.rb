require_relative '../test_config'

class HomeControllerTest < MiniTest::Test
  def app
    HomeController
  end

  def test_home_page_is_available
    get '/'
    assert last_response.ok?
  end
end
