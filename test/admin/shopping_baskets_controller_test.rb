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

      def test_can_destroy_shopping_basket
        shopping_basket_record = create :shopping_basket_record
        delete "/#{shopping_basket_record.id}"
        assert_empty ShoppingBaskets
      end

      def test_cant_distroy_customers_active_basket
        shopping_basket_record = create :shopping_basket_record
        customer_record = create :customer_record, :shopping_basket_record => shopping_basket_record
        delete "/#{shopping_basket_record.id}"
        refute_empty ShoppingBaskets
        assert_equal 'Shopping Basket could not be cleared it is still referenced', flash['error']
      end
    end
  end
end
