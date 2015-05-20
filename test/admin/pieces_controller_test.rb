require_relative '../test_config'

module UsefulMusic
  module Admin
    class PiecesControllerTest < MyRecordTest
      include ControllerTesting

      def app
        PiecesController
      end

      def test_index_page_is_available
        assert_ok get '/'
      end

      def test_index_page_shows_piece
        create :piece_record, :id => '123'
        get '/'
        assert_includes last_response.body, 'UD123'
      end

      def test_can_search_for_piece
        create :piece_record, :id => '123'
        get '/search', {search: '123'}
        assert_includes last_response.location, '123'
      end

      def test_redirects_when_no_piece
        get '/search', {search: '123'}
        assert_equal 'Could not find piece', flash['error']
        assert_equal last_response.location, '/admin/pieces'
      end

      def test_new_page_is_available
        assert_ok get '/new'
      end

      def test_can_create_piece
        post '/', {:piece => attributes_for(:piece_record, :id => 212)}
        assert_equal 212, Piece::Record.last.id
        # assert_equal '/pieces/UD212', last_response.location
      end

      def test_redirects_when_piece_exists
        create :piece_record, :id => 212
        post '/', {:piece => attributes_for(:piece_record, :id => 212)}
        assert_equal 212, Piece::Record.last.id
        assert_equal '/admin/pieces/UD212/edit', last_response.location
      end

      def test_warns_when_data_incorrect
        post '/', {:piece => {}}
        assert_equal 'Could not create invalid piece', flash['error']
        assert_equal '/admin/pieces/new', last_response.location
      end

      def test_edit_page_is_available
        record = create :piece_record, :id => 123
        assert_ok get "/UD#{record.id}/edit"
        assert_includes last_response.body, 'UD123'
      end

      def test_redirected_from_edit_if_no_piece
        get "/UD000/edit"
        assert last_response.redirect?
      end

      def test_can_update_a_piece
        record = create :piece_record, :id => 123
        put '/UD123', {:piece => attributes_for(:piece_record, :id => record.id, :title => 'All change')}
        assert_equal 'Piece updated', flash['success']
        assert_equal 'All change', Piece::Record[123].title
        assert_equal '/admin/pieces', last_response.location
      end

      def test_destroy_action_redirects_to_index
        record = create :piece_record
        delete "/UD#{record.id}"
        assert_empty Catalogue
        assert_equal '/admin/pieces', last_response.location
      end

      def test_destroys_associated_items
        item_record = create :item_record
        delete "/UD#{item_record.piece_record.id}"
        assert_empty Item::Record
      end
    end
  end
end
