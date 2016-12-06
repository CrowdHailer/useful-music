require_relative '../test_config'

module UsefulMusic
  module Admin
    class ItemsControllerTest < MyRecordTest
      include ControllerTesting

      def app
        ItemsController
      end

      def test_can_create_item
        piece_record = create :piece_record
        post '/', {:item => attributes_for(:item_record).merge(:piece => piece_record.id)}
        assert_match(/pieces\/UD#{piece_record.id}/, last_response.location)
      end

      def test_create_item_with_missing_data
        piece_record = create :piece_record
        post '/', {:item => {}.merge(:piece => piece_record.id)}
        assert_equal '/pieces', last_response.location
      end

      def test_create_item_with_invalid_data
        piece_record = create :piece_record
        post '/', {:item => attributes_for(:item_record).merge(:piece => piece_record.id, :initial_price => -1)}
        assert_equal '/pieces', last_response.location
      end

      def test_edit_page_is_available
        record = create :item_record
        assert_ok get "/#{record.id}/edit"
      end

      def test_redirected_from_edit_if_no_item
        get "/0/edit"
        assert_equal 'Item not found', flash['error']
        assert last_response.redirect?
      end

      def test_can_update_item
        record = create :item_record, :name => 'test'
        put "/#{record.id}", {:item => attributes_for(:item_record, :name => 'test').merge({:name => 'test2'})}
        assert_match /pieces\/UD\d{3}/, last_response.location
        assert_equal 'test2', Item::Record.last.name
      end

      def test_redirected_from_update_if_no_item
        put "/0"
        assert_equal 'Item not found', flash['error']
        assert last_response.redirect?
      end

      def test_can_delete_an_item
        record = create :item_record
        delete "/#{record.id}"
        assert_empty Item::Record
        assert_match /pieces\/UD\d{3}/, last_response.location
      end

      def test_cannot_delete_used_item
        item_record = create :item_record
        purchase_record = create :purchase_record, :item_record => item_record
        delete "/#{item_record.id}"
        refute_empty Item::Record
        assert_equal 'Item could not be deleted, it is still referenced', flash['error']
      end

      def test_redirected_from_delete_if_no_item
        delete "/0"
        assert_equal 'Item not found', flash['error']
        assert last_response.redirect?
      end

    end
  end
end
