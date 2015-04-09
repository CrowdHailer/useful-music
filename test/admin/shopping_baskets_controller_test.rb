require_relative '../test_config'

module UsefulMusic
  module Admin
    class ShoppingBasketsControllerTest < MyRecordTest
      include ControllerTesting

      def app
        ShoppingBasketsController
      end

      def test_index_page_is_available
        assert_ok get '/'
      end
    end
  end
end
