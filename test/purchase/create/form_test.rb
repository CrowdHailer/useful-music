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
    end
  end
end
