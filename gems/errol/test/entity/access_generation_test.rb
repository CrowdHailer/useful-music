require_relative '../test_config'

module Errol
  class EntityTest < MiniTest::Test
    def test_entry_reader_sets_reader_method
      entity = Class.new Errol::Entity do
        entry_reader :test_attribute
      end
      record = OpenStruct.new
      instance = entity.new record
      record.test_attribute = :value
      assert_equal :value, instance.test_attribute
    end

    def test_entry_writer_sets_writer_method
      entity = Class.new Errol::Entity do
        entry_writer :test_attribute
      end
      record = OpenStruct.new
      instance = entity.new record
      instance.test_attribute = :value
      assert_equal :value, record.test_attribute
    end

    def test_boolean_query_sets_query_method
      entity = Class.new Errol::Entity do
        boolean_query :test_attribute
      end
      record = OpenStruct.new
      instance = entity.new record
      record.test_attribute = :value
      assert_equal true, instance.test_attribute?
    end

    def test_entry_accessor_sets_reader_method
      entity = Class.new Errol::Entity do
        entry_accessor :test_attribute
      end
      record = OpenStruct.new
      instance = entity.new record
      record.test_attribute = :value
      assert_equal :value, instance.test_attribute
    end

    def test_entry_accessor_sets_writer_method
      entity = Class.new Errol::Entity do
        entry_accessor :test_attribute
      end
      record = OpenStruct.new
      instance = entity.new record
      instance.test_attribute = :value
      assert_equal :value, record.test_attribute
    end

    def test_boolean_accessor_sets_query_method
      entity = Class.new Errol::Entity do
        boolean_accessor :test_attribute
      end
      record = OpenStruct.new
      instance = entity.new record
      record.test_attribute = :value
      assert_equal true, instance.test_attribute?
    end

    def test_boolean_accessor_sets_writer_method
      entity = Class.new Errol::Entity do
        boolean_accessor :test_attribute
      end
      record = OpenStruct.new
      instance = entity.new record
      instance.test_attribute = :value
      assert_equal :value, record.test_attribute
    end
  end
end
