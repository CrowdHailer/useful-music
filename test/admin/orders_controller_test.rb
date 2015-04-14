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
        order = Order.new order_record
        patch "/#{order_record.id}/remind"
        assert_includes last_message.to, order.customer.email
        assert last_response.redirect?
        assert order.record.reload.reminded_at
      end

      def test_cant_send_reminder_to_missing_order
        assert_raises Errol::Repository::RecordAbsent do
          patch "/1/remind"
        end
      end

      def test_reminds_all
        clear_mail
        cancelled_order = Order.new create(:order_record)
        reminded_order = Order.new create(:order_record, :completed_at => DateTime.new(2015,4,5), :reminded_at => DateTime.new(2015,4,7))
        to_remind = Order.new create(:order_record, :completed_at => DateTime.new(2015, 5, 1))
        new_order = Order.new create(:order_record, :completed_at => DateTime.new(2015, 5, 3))
        today = DateTime.new(2015, 5, 5)
        DateTime.stub :now, today do
          patch '/remind'
        end
        assert_equal 1, Mail::TestMailer.deliveries.count
        assert_includes last_message.to, to_remind.customer.email
      end
    end
  end
end
