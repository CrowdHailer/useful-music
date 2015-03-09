require_relative '../test_config'

module UsefulMusic
  module Admin
    class CustomersControllerTest < MyRecordTest
      include ControllerTesting
      include MailerTesting

      def app
        CustomersController
      end

      def test_index_page_is_available
        assert_ok get '/'
      end

      def test_index_shows_customer
        create :customer_record, :first_name => 'Issac'
        get '/'
        assert_includes last_response.body, 'Issac'
      end

      def test_can_make_admin
        customer_record = create :customer_record
        post "/#{customer_record.id}/admin"
        assert customer_record.reload.admin
        assert flash['success']
        assert last_response.redirect?
      end

      def test_redirects_if_customer_not_found
        post "/1/admin"
        assert 'Customer not found', flash['error']
        assert last_response.redirect?
      end
    end
  end
end
