require_relative '../../test_config'

class Item
  class Create
    class FormTest < MyRecordTest
      def test_obtains_piece
        piece_record = create :piece_record
        form = Form.new :piece => piece_record.id
        assert_equal piece_record, form.piece.record
      end

      def test_nil_if_piece_does_not_exist
        form = Form.new :piece => 3
        assert_nil form.piece
      end

      def test_nil_if_no_piece_id_sent
        form = Form.new
        assert_nil form.piece
      end

      def test_obtains_name
        form = Form.new :name => 'all parts'
        assert_equal 'all parts', form.name
      end

      def test_strips_whitespace_from_name
        form = Form.new :name => '   flute part  '
        assert_equal 'flute part', form.name
      end

      def test_silent_if_name_not_supplied
        form = Form.new
        assert_equal '', form.name
      end

      def test_obtains_initial_price
        form = Form.new :initial_price => '3.20'
        assert_equal Money.new(320, 'gbp'), form.initial_price
      end

      def test_silent_if_initial_price_empty
        form = Form.new :initial_price => ''
        assert_nil form.initial_price
      end

      def test_silent_if_initial_price_nil
        form = Form.new
        assert_nil form.initial_price
      end

      def test_obtains_discounted_price
        form = Form.new :discounted_price => '3.20'
        assert_equal Money.new(320, 'gbp'), form.discounted_price
      end

      def test_silent_if_initial_price_empty
        form = Form.new :discounted_price => ''
        assert_nil form.discounted_price
      end

      def test_silent_if_initial_price_nil
        form = Form.new
        assert_nil form.discounted_price
      end
    end
  end
end
