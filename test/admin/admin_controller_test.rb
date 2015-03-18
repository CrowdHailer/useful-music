require_relative '../test_config'

module UsefulMusic
  class AdminControllerTest < MyRecordTest
    include ControllerTesting
    include MailerTesting

    def app
      AdminController
    end

    def test_index_page_is_available_to_admin
      assert_ok get '/', {}, {'rack.session' => { :user_id => admin.id }}
    end

    def test_index_page_is_not_available_to_customer
      get '/', {}, {'rack.session' => { :user_id => customer.id }}
      assert_equal 'Access denied', flash['error']
      assert last_response.redirect?
    end

    def test_guest_is_redirected_to_login
      get '/', {}, {}
      assert_equal 'Login required', flash['error']
      assert_equal '/sessions/new?requested_path=/admin', last_response.location
    end
  end
end
