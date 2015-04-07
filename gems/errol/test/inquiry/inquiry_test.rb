require_relative '../test_config'

module Errol
  class InquiryTest < MiniTest::Test
    def inquiry_class
      @inquiry_class ||= Class.new(Inquiry)
    end

    def inquiry
      @inquiry ||= inquiry_class.new
    end

    def teardown
      @inquiry_class = nil
      @inquiry = nil
    end

    def test_can_set_paginate_false
      inquiry_class.default :paginate, false
      assert_equal false, inquiry.paginate?
    end

    def test_throws_error_for_undefined_value
      err = assert_raises Inquiry::DefaultValueUndefined do
        inquiry.random
      end
      assert_match(/random/, err.message)
    end

    def test_can_set_arbitrary_number_of_defaults
      inquiry_class.default :filter_a, []
      inquiry_class.default :filter_b, :ballon
      assert_equal [], inquiry.filter_a
      assert_equal :ballon, inquiry.filter_b
    end

    def test_can_set_with_string
      inquiry_class.default 'filter', :ballon
      assert_equal :ballon, inquiry.filter
    end

    def test_can_check_if_value_set
      inquiry_class.default :filter, :ballon
      assert_equal true, inquiry.filter?
    end

    def test_can_over_write_on_initialize
      inquiry_class.default :filter, :ballon
      assert_equal :smidge, inquiry_class.new(:filter => :smidge).filter
    end

    def test_can_over_write_on_initialize_with_string
      inquiry_class.default :filter, :ballon
      assert_equal :smidge, inquiry_class.new('filter' => :smidge).filter
    end
  end
end
