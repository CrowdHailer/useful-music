require_relative '../test_config'

class ArrangementsControllerTest < MiniTest::Test
  include ControllerTesting
  
  def app
    ArrangementsController
  end

  # def test_home_page_is_available
  #   get '/'
  #   assert last_response.ok?
  # end

  def test_new_page_is_available
    get '/new'
    assert last_response.ok?
  end
end
