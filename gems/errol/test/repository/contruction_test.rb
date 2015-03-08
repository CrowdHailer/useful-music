require_relative '../test_config'
require_relative './query_test'

class Item < Sequel::Model(:items)
  def name=(name)
    super name.reverse
  end
end

class RepositoryQueyTest < RecordTest
  def test_can_build_new_record
    assert_equal Item.new, TestRepository.build.__getobj__
  end

  def test_can_build_new_record_with_name
    assert_equal 'ylurnu', TestRepository.build(:name => 'unruly').name
  end

  def test_build_yields_to_block
    mock = MiniTest::Mock.new
    mock.expect :record, true, [Item.new]
    TestRepository.build do |item|
      mock.record item.__getobj__
    end
    mock.verify
  end

  def test_can_save_an_item
    # TODO incorperate, update.amend/renew/revise, remove/obliterate/withdraw
    item = SimpleDelegator.new Item.new
    TestRepository.save(item)
    refute_empty TestRepository
  end

  def test_save_returns_repository
    item = SimpleDelegator.new Item.new
    assert_equal TestRepository, TestRepository.save(item)
  end

  def test_can_remove_an_item
    item = SimpleDelegator.new Item.create
    TestRepository.remove(item)
    assert_empty TestRepository
  end

  def test_cant_remove_missing_item
    item = SimpleDelegator.new Item.new
    assert_raises Errol::Repository::RecordAbsent do
      TestRepository.remove(item)
    end
  end

  def test_remove_returns_repository
    item = SimpleDelegator.new Item.create
    assert_equal TestRepository, TestRepository.remove(item)
  end

  def test_can_create_item
    TestRepository.create
    refute_empty TestRepository
  end
end
