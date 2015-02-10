require_relative '../test_config'

class Item
  class EntityTest < MyRecordTest
    def item
      @item ||= Item.new record
    end

    def record
      @record ||= OpenStruct.new
    end

    def full_price
      Money.new(120)
    end

    def teardown
      @item = nil
      @record = nil
    end

    def test_can_access_name
      record.name = 'Sinatra'
      assert_equal 'Sinatra', item.name
    end

    def test_can_set_name
      item.name = 'Sinatra'
      assert_equal 'Sinatra', record.name
    end

    def test_can_access_initial_price
      record.initial_price = full_price
      assert_equal full_price, item.initial_price
    end

    def test_can_set_initial_price
      item.initial_price = full_price
      assert_equal full_price, record.initial_price
    end

    def test_can_access_subsequent_price
      record.subsequent_price = full_price
      assert_equal full_price, item.subsequent_price
    end

    def test_uses_initial_price_if_subsequent_price_undefined
      record.initial_price = full_price
      assert_equal full_price, item.subsequent_price
    end

    def test_can_set_subsequent_price
      item.subsequent_price = full_price
      assert_equal full_price, record.subsequent_price
    end
  end
end
