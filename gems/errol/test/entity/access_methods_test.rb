require_relative '../test_config'

module Errol
  class EntityTest < MiniTest::Test
    def test_set_sends_to_self
      entity = Class.new Errol::Entity do
        entry_accessor :test_attribute
      end
      record = OpenStruct.new
      entity.new(record).set :test_attribute => 25
      assert_equal 25, record.test_attribute
    end

    def test_set_returns_self
      entity = Class.new Errol::Entity do
        entry_accessor :test_attribute
      end
      record = OpenStruct.new
      instance = entity.new(record)
      out = instance.set :test_attribute => 25
      assert_equal instance, out
    end

    # def test_save_after_set
    #   mock_repo.expect :save, mock_repo, [instance]
    #   instance.stub :set, instance do
    #     instance.set!
    #   end
    #   mock_repo.verify
    # end
  end
end
