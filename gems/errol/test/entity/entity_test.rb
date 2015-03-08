require_relative '../test_config'

module Errol
  class EntityTest < MiniTest::Test
    def mock_repo
      @mock_repo ||= MiniTest::Mock.new
    end

    def mock_record
      @mock_record ||= MiniTest::Mock.new
    end

    def klass
      return @klass if @klass
      @klass = Class.new(Errol::Entity)
      @klass.repository = mock_repo
      @klass
    end

    def instance
      @instance ||= klass.new(mock_record)
    end

    def teardown
      @mock_repo = nil
      @mock_record = nil
      @klass = nil
      @instance = nil
    end

    def test_raises_informative_error_on_class_before_repository_set
      klass = Class.new(Errol::Entity)
      assert_raises Errol::Entity::RepositoryUndefined do
        klass.repository
      end
    end

    def test_raises_informative_error_on_instance_before_repository_set
      klass = Class.new(Errol::Entity)
      assert_raises Errol::Entity::RepositoryUndefined do
        klass.new(:a).repository
      end
    end

    def test_sets_repository_on_instance
      assert_equal mock_repo.object_id, klass.new(mock_record).repository.object_id
    end

    def test_sets_repository_on_class
      assert_equal mock_repo.object_id, klass.repository.object_id
    end

    def test_entry_reader_sets_reader_method
      klass.entry_reader :a
      mock_record.expect :a, 4
      assert_equal 4, instance.a
    end

    def test_entry_writer_set_writer_method
      klass.entry_writer :a
      mock_record.expect :a=, :random, [4]
      instance.a = 4
      mock_record.verify
    end

    def test_boolean_query_sets_query_method
      klass.boolean_query :a
      mock_record.expect :a, true
      assert_equal true, instance.a?
    end

    def test_entry_accessor_sets_reader_method
      klass.entry_accessor :a
      mock_record.expect :a, 4
      assert_equal 4, instance.a
    end

    def test_entry_accessor_set_writer_method
      klass.entry_accessor :a
      mock_record.expect :a=, :random, [4]
      instance.a = 4
      mock_record.verify
    end

    def test_boolean_accessor_sets_query_method
      klass.boolean_accessor :a
      mock_record.expect :a, true
      assert_equal true, instance.a?
    end

    def test_boolean_accessor_set_writer_method
      klass.boolean_accessor :a
      mock_record.expect :a=, :random, [4]
      instance.a = 4
      mock_record.verify
    end

    def test_make_available_id
      mock_record.expect :id, 4
      assert_equal 4, instance.id
    end

    def test_sets_multiple_entries
      assert_raises NoMethodError do
        instance.set :a => 4
      end
    end

    def test_set_returns_self
      klass.entry_accessor :a
      mock_record.expect :a=, true, [4]
      assert_equal instance.object_id, instance.set(:a => 4).object_id
    end

    def test_equal_if_wrapping_same_record
      klass = Class.new(Errol::Entity)
      assert_equal klass.new(:a), klass.new(:a)
    end

    def test_not_equal_for_different_records
      klass = Class.new(Errol::Entity)
      refute_equal klass.new(:b), klass.new(:a)
    end

    def test_not_equal_if_different_classes
      klass1 = Class.new(Errol::Entity)
      klass2 = Class.new(Errol::Entity)
      refute_equal klass1.new(:a), klass2.new(:a)
    end


    # def test_bang
    #   mock_repo.expect :save, mock_repo, [instance]
    #   instance.stub :set, instance do
    #     instance.set!
    #   end
    #   mock_repo.verify
    # end

    def test_undefined_bang
      assert_raises NoMethodError do
        instance.random!
      end
    end
  end
end
