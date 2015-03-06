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
    end
  end
end
