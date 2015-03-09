require_relative '../../test_config'

class Purchase
  class Create
    class FormTest < MyRecordTest
      def test_obtains_quantity
        form = Form.new :quantity => 2
        assert_equal 2, form.quantity
      end

      def test_quantity_zero_from_nil
        form = Form.new :quantity => nil
        assert_equal 0, form.quantity
      end

      def test_quantity_zero_from_empty_string
        form = Form.new :quantity => ''
        assert_equal 0, form.quantity
      end

      def test_quantity_zero_from_unknown_string
        form = Form.new :quantity => 'random'
        assert_equal 0, form.quantity
      end

      def test_obtains_item
        item_record = create :item_record
        form = Form.new :item => item_record.id
        assert_equal item_record, form.item.record
      end

      def test_nil_if_item_does_not_exist
        form = Form.new :item => 3
        assert_nil form.item
      end

      def test_nil_if_no_item_id_sent
        form = Form.new
        assert_nil form.item
      end

      def test_obtains_shopping_basket
        shopping_basket_record = create :shopping_basket_record
        form = Form.new :shopping_basket => shopping_basket_record.id
        assert_equal shopping_basket_record, form.shopping_basket.record
      end

      def test_nil_if_shopping_basket_does_not_exist
        form = Form.new :shopping_basket => 3
        assert_nil form.shopping_basket
      end

      def test_nil_if_no_shopping_basket_id_sent
        form = Form.new
        assert_nil form.shopping_basket
      end
    end
  end
end
