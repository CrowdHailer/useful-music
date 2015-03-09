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

    def test_calculates_price_of_single_single_price_item
      record.initial_price = Money.new(100)
      assert_equal Money.new(100, 'gbp'), item.price_for(1)
    end

    def test_calculates_price_of_several_single_price_items
      record.initial_price = Money.new(100)
      assert_equal Money.new(300, 'gbp'), item.price_for(3)
    end

    def test_calculates_discount_on_subsequent_pricing
      record.initial_price = Money.new(100)
      record.discounted_price = Money.new(50)
      assert_equal Money.new(200, 'gbp'), item.price_for(3)
    end

    def test_shows_if_multibuy_available
      record.discounted_price = Money.new(50)
      assert item.multibuy_discount?
    end

    def test_shows_if_multibuy_unavailable
      refute item.multibuy_discount?
    end


    ################# Associations #####################

    def test_has_piece
      @record = create :item_record
      assert_equal Piece, item.piece.class
    end

    def test_does_not_have_piece_if_no_piece_record
      assert_nil item.piece
    end

    def test_can_set_piece
      piece = Piece.new(create :piece_record)
      @record = create :item_record
      item.piece = piece
      assert_equal piece.record, item.record.piece_record
    end

    ################# Archive #####################

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

    def test_can_access_discounted_price
      record.discounted_price = full_price
      assert_equal full_price, item.discounted_price
    end

    def test_can_set_discounted_price
      item.discounted_price = full_price
      assert_equal full_price, record.discounted_price
    end

    # TODO consider appropriate file type for testing
    def test_can_access_asset
      record.asset = :asset
      assert_equal :asset, item.asset
    end

    def test_can_set_initial_price
      item.asset = :asset
      assert_equal :asset, record.asset
    end
  end
end
