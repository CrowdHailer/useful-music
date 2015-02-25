require_relative '../test_config'

class PasswordResetsControllerTest < MyRecordTest
  include ControllerTesting

  def app
    PasswordResetsController
  end

  def test_new_page_is_available
    assert_ok get '/new'
  end
end
