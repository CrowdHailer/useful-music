require_relative '../test_config'

class PasswordResetsControllerTest < MyRecordTest
  include ControllerTesting

  def app
    PasswordResetsController
  end

  def test_new_page_is_available
    assert_ok get '/new'
  end

  def test_create_reset
    post '/', :customer => {:email => 'a@b.com'}

  end
end
