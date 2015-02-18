require_relative '../test_config'

class ShoppingBasket
  class EntityTest < MyRecordTest
    def shopping_basket
      @shopping_basket ||= ShoppingBasket.new record
    end

    def record
      @record ||= OpenStruct.new
    end

    def teardown
      @shopping_basket = nil
      @record = nil
    end

    def test_has_purchases
      purchase_record = create :purchase_record
      @record = ShoppingBasket::Record.last
      assert_equal Purchase, shopping_basket.purchases.first.class
    end
  end
end
