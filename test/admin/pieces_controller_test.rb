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

      def test_index_page_shows_discount
        create :piece_record, :id => '123'
        get '/'
        assert_includes last_response.body, 'UD123'
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
        assert_equal '/pieces/UD212/edit', last_response.location
      end

      def test_warns_when_data_incorrect
        post '/', {:piece => {}}
        assert_equal 'Could not create invalid piece', flash['error']
        assert_equal '/pieces/new', last_response.location
      end
    end
  end
end
