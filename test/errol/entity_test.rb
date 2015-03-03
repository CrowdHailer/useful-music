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

    def test_sets_repository_on_instance
      assert_equal mock_repo.object_id, klass.new(mock_record).repository.object_id
    end

    def test_sets_repository_on_class
      assert_equal mock_repo.object_id, klass.repository.object_id
    end

    def test_entry_reader
      klass.entry_reader :a
      mock_record.expect :a, 4
      mock_record.expect :nil?, false
      assert_equal 4, instance.a
    end

    def test_entry_writer
      klass.entry_writer :a
      mock_record.expect :a=, :random, [4]
      mock_record.expect :nil?, false
      instance.a = 4
      mock_record.verify
    end

    def test_entry_writer
      # Maybe return self
      klass.entry_writer :a
      mock_record.expect :a=, :random, [4]
      mock_record.expect :nil?, false
      returned = (instance.a = 4)
      # ap returned
    end

    def test_bang
      mock_repo.expect :save, mock_repo, [instance]
      instance.stub :set, instance do
        instance.set!
      end
      mock_repo.verify
    end

    def test_undefined_bang
      assert_raises NoMethodError do
        instance.random!
      end
    end
  end
end
