require_relative '../test_config'

class SessionsControllerTest < MyRecordTest
  include ControllerTesting
  include MailerTesting

  def app
    SessionsController
  end

  def test_new_page_is_available
    assert_ok get '/new'
  end

  def test_redirect_to_account_if_logged_in
    skip
  end
end
