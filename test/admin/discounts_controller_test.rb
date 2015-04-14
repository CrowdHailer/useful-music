require_relative '../test_config'

module UsefulMusic
  module Admin
    class DiscountsControllerTest < MyRecordTest
      include ControllerTesting

      def app
        DiscountsController
      end

      def test_index_page_is_available
        assert_ok get '/'
      end

      def test_index_page_shows_discount
        create :discount_record, :code => 'TEST123'
        get '/'
        assert_includes last_response.body, 'TEST123'
      end

      def test_new_page_is_available
        assert_ok get '/new'
      end

      def test_can_create_discount
        post '/', {:discount => attributes_for(:discount_record)}
        assert_equal 'Discount Created', flash['success']
        assert last_response.redirect?
        refute_empty Discounts
      end


      def test_edit_page_is_available
        discount_record = create :discount_record
        assert_ok get "/#{discount_record.id}/edit"
      end

      def test_can_update
        discount_record = create :discount_record
        put "/#{discount_record.id}", {:discount => attributes_for(:discount_record).merge({:code => 'NEW21'})}
        assert_equal 'NEW21', discount_record.reload.code
      end

      def test_can_destroy_discount_record
        discount_record = create :discount_record
        delete "/#{discount_record.id}"
        assert_empty Discounts
      end

      def test_cannot_distroy_used_discount
        shopping_basket_record = create :shopping_basket_record, :discount_record => create(:discount_record)
        order_record = create :order_record, :shopping_basket_record => shopping_basket_record
        delete "/#{order_record.discount_record.id}"
        refute_empty Discounts
        assert_equal 'Discount could not be delete, it has been used', flash['error']
      end

    end
  end
end
