require_relative '../test_config'

module Errol
  class RepoTest < MiniTest::Test
    def mock_record
      @mock_record ||= OpenStruct
    end

    def mock_entity
      @mock_entity ||= SimpleDelegator
    end

    def klass
      return @klass if @klass
      @klass = Class.new(Errol::Repo)
      @klass.record_class = mock_record
      @klass.entity_class = mock_entity
      @klass
    end

    # def test_case_name
    #   puts klass.record
    #   ap klass::Query
    # end

    def test_build_single_hash
      res = klass.build({:a => 1}) do |entity|
        ap entity
      end
      ap res
      ap klass.build({:a => 1})
      klass.build({:a => 1}, &:save)
    end
    #
    # def test_single_named
    #   res = klass.build(:a => 1, :b => 2) do |entity|
    #     ap entity.__getobj__
    #   end
    # end
    #
    # def test_array
    #   first, second = klass.build([{:a => 1}, {:a => 2}]) do |entity|
    #     ap 's'
    #     ap entity.__getobj__
    #   end
    # end
    #
    # def test_empty
    #   klass.build do |entity|
    #     ap entity
    #   end
    # end
  end
end
