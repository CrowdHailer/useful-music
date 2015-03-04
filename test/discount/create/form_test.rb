require_relative '../../test_config'

class Discount
  class Create
    class FormTest < MiniTest::Test
      def test_obtains_code
        form = Form.new :code => 'CODE001'
        assert_equal 'CODE001', form.code
      end

      def test_capitalises_first_name
        form = Form.new :code => 'code001'
        assert_equal 'CODE001', form.code
      end

      def test_strips_whitespace_from_first_name
        form = Form.new :code => '   CODE001  '
        assert_equal 'CODE001', form.code
      end

      def test_silent_if_first_name_not_supplied
        form = Form.new
        assert_equal '', form.code
      end

      def test_obtains_value
        form = Form.new :value => '3.20'
        assert_equal Money.new(320, 'gbp'), form.value
      end

      def test_silent_if_value_empty
        form = Form.new :value => ''
        assert_nil form.value
      end

      def test_obtains_allocation
        form = Form.new :allocation => '2'
        assert_equal 2, form.allocation
      end

      def test_silent_if_allocation_empty
        form = Form.new :allocation => ''
        assert_nil form.allocation
      end

      def test_obtains_customer_allocation
        form = Form.new :customer_allocation => '2'
        assert_equal 2, form.customer_allocation
      end

      def test_silent_if_customer_allocation_empty
        form = Form.new :customer_allocation => ''
        assert_nil form.customer_allocation
      end

      def test_obtains_start_datetime
        form = Form.new :start_datetime => '2016-10-6'
        assert_equal DateTime.new(2016, 10, 6), form.start_datetime
      end

      def test_silent_if_start_datetime_empty
        form = Form.new :start_datetime => ''
        assert_nil form.start_datetime
      end

      def test_obtains_end_datetime
        form = Form.new :end_datetime => '2016-10-8'
        assert_equal DateTime.new(2016, 10, 8), form.end_datetime
      end

      def test_silent_if_end_datetime_empty
        form = Form.new :end_datetime => ''
        assert_nil form.end_datetime
      end
    end
  end
end
