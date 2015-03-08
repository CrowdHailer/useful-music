require_relative '../test_config'

module UsefulMusic
  module Admin
    class ItemsControllerTest < MyRecordTest
      include ControllerTesting

      def app
        ItemsController
      end

      def test_new_page_is_available
        record = create :piece_record
        assert_ok get "/new?piece_id=#{record.id}"
        assert_includes last_response.body, "UD#{record.id}"
      end

      def test_no_new_page_for_missing_piece_to_admin
        assert_raises Errol::Repository::RecordAbsent do
          get "/new?piece_id=100"
        end
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

      def test_can_update_item_as_admin
        record = create :item_record, :name => 'test'
        put "/#{record.id}", {:item => attributes_for(:item_record, :name => 'test').merge({:name => 'test2'})}
        assert_match /pieces\/UD\d{3}/, last_response.location
        assert_equal 'test2', Item::Record.last.name
      end

      def test_can_delete_an_item
        record = create :item_record
        delete "/#{record.id}"
        assert_empty Item::Record
        assert_match /pieces\/UD\d{3}/, last_response.location
      end

    end
  end
end
