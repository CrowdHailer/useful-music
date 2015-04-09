require_relative '../test_config'

module UsefulMusic
  module Admin
    class OrdersControllerTest < MyRecordTest
      include ControllerTesting

      def app
        OrdersController
      end

      def test_index_page_is_available
        assert_ok get '/'
      end
    end
  end
end
