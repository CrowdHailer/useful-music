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

    end
  end
end
