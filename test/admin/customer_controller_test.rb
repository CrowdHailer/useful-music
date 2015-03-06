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
    end
  end
end
