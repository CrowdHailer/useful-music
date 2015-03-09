require_relative '../test_config'

class Inquiry < Errol::Inquiry
  default :show_offers, false
end

class TestRepository < Errol::Repository
  def self.record_class
    Item
  end

  def dataset
    dataset = raw_dataset

    inquiry.show_offers? ? dataset.where(:discounted) : dataset

  end

  def self.inquiry(requirements)
    Inquiry.new(requirements)
  end

  def self.dispatch(record)
    SimpleDelegator.new record
  end

  def self.receive(entity)
    entity.__getobj__
  end
end


class RepositoryQueyTest < RecordTest
  def items
    DB[:items]
  end

  def test_repository_starts_empty
    assert_equal true, TestRepository.empty?
  end

  def test_repository_not_empty_with_item
    items.insert(:name => 'abc')
    assert_equal false, TestRepository.empty?
  end

  def test_filtered_repository_is_empty
    items.insert(:name => 'abc', :discounted => false)
    assert_equal true, TestRepository.empty?(:show_offers => true)
  end

  def test_repository_starts_with_count_zero
    assert_equal 0, TestRepository.count
  end

  def test_respository_counts_one_item
    items.insert(:name => 'abc')
    assert_equal 1, TestRepository.count
  end

  def test_filtered_repository_counts_zero_items
    items.insert(:name => 'abc', :discounted => false)
    assert_equal 0, TestRepository.count(:show_offers => true)
  end

  def test_can_get_first_item
    item = Item.create(:name => 'abc')
    assert_equal item, TestRepository.first.__getobj__
  end

  def test_wraps_first_item
    items.insert(:name => 'abc')
    assert_equal SimpleDelegator, TestRepository.first.class
  end

  def test_returns_nil_for_no_first_item
    assert_nil TestRepository.first
  end

  def test_returns_first_filtered_item
    items.insert(:name => 'abc', :discounted => false)
    i = items.insert(:name => 'abc', :discounted => true)
    items.insert(:name => 'abc', :discounted => false)
    assert_equal i, TestRepository.first(:show_offers => true).id
  end

  def test_can_get_last_item
    item = Item.create(:name => 'abc')
    assert_equal item, TestRepository.last.__getobj__
  end

  def test_wraps_last_item
    items.insert(:name => 'abc')
    assert_equal SimpleDelegator, TestRepository.last.class
  end

  def test_returns_nil_for_no_last_item
    assert_nil TestRepository.last
  end

  def test_returns_last_filtered_item
    items.insert(:name => 'abc', :discounted => false)
    i = items.insert(:name => 'abc', :discounted => true)
    items.insert(:name => 'abc', :discounted => false)
    assert_equal i, TestRepository.last(:show_offers => true).id
  end

  def test_can_find_item_by_id
    item = Item.create(:name => 'abc')
    assert_equal item, TestRepository[item.id].__getobj__
  end

  def test_wraps_found_item
    item = Item.create(:name => 'abc')
    assert_equal SimpleDelegator, TestRepository[item.id].class
  end

  def test_returns_nil_for_no_found_item
    assert_nil TestRepository[2]
  end

  def test_returns_nil_on_filtered_find
    item = Item.create(:name => 'abc')
    assert_nil TestRepository[item.id, :show_offers => true]
  end

  def test_can_fetch_item_by_id
    item = Item.create(:name => 'abc')
    assert_equal item, TestRepository.fetch(item.id).__getobj__
  end

  def test_wraps_fetched_item
    item = Item.create(:name => 'abc')
    assert_equal SimpleDelegator, TestRepository.fetch(item.id).class
  end

  def test_raises_error_for_no_fetched_item
    err = assert_raises Errol::Repository::RecordAbsent do
      TestRepository.fetch(2)
    end
    assert_equal 'TestRepository contains no record with id: 2', err.message
  end

  def test_raises_error_on_filtered_fetch
    item = Item.create(:name => 'abc')
    assert_raises Errol::Repository::RecordAbsent do
      TestRepository.fetch(item.id, :show_offers => true)
    end
  end

  def test_fetch_calls_block_for_missing_item
    mock = MiniTest::Mock.new
    mock.expect :record, true, [2]
    TestRepository.fetch(2) { |id| mock.record id }
  end

  def test_returns_all_items
    item = Item.create(:name => 'abc')
    assert_equal [item], TestRepository.all.map(&:__getobj__)
  end

  def test_wraps_all_items
    item = Item.create(:name => 'abc')
    assert_equal [SimpleDelegator], TestRepository.all.map(&:class)
  end

  def test_filters_all_records
    discounted = Item.create(:name => 'abc', :discounted => true)
    Item.create(:name => 'abc')
    assert_equal [discounted], TestRepository.all(:show_offers => true).map(&:__getobj__)
  end

  def test_can_get_each_item_in_repository
    item = Item.create(:name => 'abc')
    mock = MiniTest::Mock.new
    mock.expect :record, true, [item]
    TestRepository.each { |entity| mock.record entity.__getobj__ }
    mock.verify
  end

  def test_can_get_each_item_in_filtered_repository
    item = Item.create(:name => 'abc')
    discounted = Item.create(:name => 'abc', :discounted => true)
    mock = MiniTest::Mock.new
    mock.expect :record, true, [discounted]
    TestRepository.each(:show_offers => true) { |entity| mock.record entity.__getobj__ }
    mock.verify
  end

end
