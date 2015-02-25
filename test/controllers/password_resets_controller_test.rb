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
    skip
  end

  def test_rerenders_when_email_not_found
    assert_ok post '/', :customer => {:email => 'a@b.com'}
    assert_includes last_response.body, 'Email not found'
  end
end
