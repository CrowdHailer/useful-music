require_relative '../test_config'

module Errol
  class Repository
    class QueryTest < MiniTest::Test
      def query_klass
        @query_klass ||= Class.new(Query)
      end

      def teardown
        @query_klass = nil
      end

      def test_starts_with_paginate_true
        assert_equal true, query_klass.new.paginate?
      end

      def test_can_set_paginate_false
        query_klass.default :paginate, false
      end

      def test_throws_error_for_undefined_value
        err = assert_raises Query::DefaultValueUndefined do
          query_klass.new.random
        end
        assert_match(/random/, err.message)
      end

      def test_can_set_arbitrary_number_of_defaults
        query_klass.default :filter_a, []
        query_klass.default :filter_b, :ballon
        assert_equal [], query_klass.new.filter_a
        assert_equal :ballon, query_klass.new.filter_b
      end

      def test_can_set_with_string
        query_klass.default 'filter', :ballon
        assert_equal :ballon, query_klass.new.filter
      end

      def test_can_check_if_value_set
        query_klass.default :filter, :ballon
        assert_equal true, query_klass.new.filter?
      end

      def test_can_over_write_on_initialize
        query_klass.default :filter, :ballon
        assert_equal :smidge, query_klass.new(:filter => :smidge).filter
      end

      def test_can_over_write_on_initialize_with_string
        query_klass.default :filter, :ballon
        assert_equal :smidge, query_klass.new('filter' => :smidge).filter
      end

    end
  end
end
