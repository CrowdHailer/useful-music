require_relative '../test_config'

class PaginatedInquiry < Errol::Inquiry
  default :page, 1
  default :page_size, 2
end

class PaginatedRepository < Errol::Repository
  def self.record_class
    Item
  end

  def dataset
    dataset = raw_dataset
  end

  def self.inquiry(requirements)
    PaginatedInquiry.new(requirements)
  end

  def self.dispatch(record)
    SimpleDelegator.new record
  end

  def self.receive(entity)
    entity.__getobj__
  end
end

class DemoRepositoryQueyTest < RecordTest
  def items
    DB[:items]
  end

  def first
    @first ||= items.insert({})
  end

  def second
    @second ||= items.insert({})
  end

  def third
    @third ||= items.insert({})
  end

  def setup
    first
    second
    third
  end

  def teardown
    @first = nil
    @second = nil
    @third = nil
  end

  def test_can_get_first_page_number
    page = PaginatedRepository.new
    assert_equal 1, page.current_page
  end

  def test_can_get_first_page_size
    page = PaginatedRepository.new
    assert_equal 2, page.page_size
  end

  def test_identifies_as_first_page
    page = PaginatedRepository.new
    assert page.first_page?
  end

  def test_identifies_as_not_first_page
    page = PaginatedRepository.new :page => 2
    refute page.first_page?
  end

  def test_identifies_as_last_page
    page = PaginatedRepository.new :page => 2
    assert page.last_page?
  end

  def test_identifies_as_not_first_page
    page = PaginatedRepository.new
    refute page.last_page?
  end

  def test_can_get_page_count_from_each_page
    page = PaginatedRepository.new
    assert_equal 2, page.page_count
  end

  def test_can_get_page_range
    page = PaginatedRepository.new
    assert_equal 1..2, page.page_range
  end

  def test_can_get_next_page
    page = PaginatedRepository.new
    assert_equal 2, page.next_page
  end

  def test_can_get_previous_page
    page = PaginatedRepository.new
    assert_equal nil, page.previous_page
  end

  def test_page_reports_not_empty
    page = PaginatedRepository.new
    refute_empty page
  end

  def test_page_reports_empty
    page = PaginatedRepository.new :page => 3
    assert_empty page
  end

  def test_counts_page_items
    page = PaginatedRepository.new :page => 2
    assert_equal 1, page.count
  end

  def test_can_get_first_item_on_second_page
    page = PaginatedRepository.new :page => 2
    assert_equal third, page.first.id
  end

  def test_can_get_last_item_on_first_page
    page = PaginatedRepository.new :page => 1
    assert_equal second, page.last.id
  end

  # def test_nil_if_not_found_on_page
  #   # TODO note pagination applied after filtering so finds record
  #   page = PaginatedRepository.new :page => 1
  #   assert_nil page[third]
  # end

  def test_can_get_all_items_on_second_page
    page = PaginatedRepository.new :page => 2
    assert_equal [third], page.all.map{ |entity| entity.id }
  end

  def test_can_get_each_item_on_page
    mock = MiniTest::Mock.new
    mock.expect :record, true, [third]
    page = PaginatedRepository.new :page => 2
    page.each { |entity| mock.record entity.id }
    mock.verify
  end

  def test_each_method_returns_self
    page = PaginatedRepository.new :page => 2
    assert_equal page, page.each{}
  end

  def test_can_map_items_on_page
    page = PaginatedRepository.new :page => 2
    assert_equal [3], page.map(&:id)
  end

end
