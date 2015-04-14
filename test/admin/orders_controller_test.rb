require_relative '../test_config'

module UsefulMusic
  module Admin
    class OrdersControllerTest < MyRecordTest
      include ControllerTesting
      include MailerTesting

      def app
        OrdersController
      end

      def test_index_page_is_available
        assert_ok get '/'
      end

      def test_index_page_is_available_with_orders
        create :order_record
        assert_ok get '/'
      end

      def test_sends_reminder
        clear_mail
        order_record = create :order_record
        patch "/#{order_record.id}/remind"
        ap last_message
        assert last_message
      end

      def test_cant_send_reminder_to_missing_order
        assert_raises Errol::Repository::RecordAbsent do
          patch "/1/remind"
        end

      end
    end
  end
end
