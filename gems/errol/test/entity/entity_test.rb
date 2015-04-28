require_relative '../test_config'

module Errol
  class EntityTest < MiniTest::Test

    def test_make_available_id
      klass = Class.new(Errol::Entity)
      record = OpenStruct.new :id => 4
      instance = klass.new record
      assert_equal 4, instance.id
    end

    def test_equal_if_wrapping_same_record
      klass = Class.new(Errol::Entity)
      assert_equal klass.new(:record), klass.new(:record)
    end

    def test_not_equal_for_different_records
      klass = Class.new(Errol::Entity)
      refute_equal klass.new(:record_b), klass.new(:record_a)
    end

    def test_not_equal_if_different_classes
      klass1 = Class.new(Errol::Entity)
      klass2 = Class.new(Errol::Entity)
      refute_equal klass1.new(:record), klass2.new(:record)
    end

    # def test_undefined_bang
    #   assert_raises NoMethodError do
    #     instance.random!
    #   end
    # end
  end
end
