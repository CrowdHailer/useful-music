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

    def test_has_order
      order_record = create :order_record
      @record = ShoppingBasket::Record.last
      assert_equal Order, shopping_basket.order.class
    end

    def test_no_order_if_no_order_record
      @record = create :shopping_basket_record
      assert_nil shopping_basket.order
    end

    def test_has_price_from_all_purchases
      shopping_basket.stub :purchases, [
        OpenStruct.new(:price => Money.new(120)),
        OpenStruct.new(:price => Money.new(400))
      ] do
        assert_equal Money.new(520), shopping_basket.price
      end
    end

    def test_has_number_of_purchases
      shopping_basket.stub :purchases, [
        OpenStruct.new,
        OpenStruct.new
      ] do
        assert_equal 2, shopping_basket.number_of_purchases
      end
    end

    def test_has_number_of_licenses
      shopping_basket.stub :purchases, [
        OpenStruct.new(:quantity => 2),
        OpenStruct.new(:quantity => 2)
      ] do
        assert_equal 4, shopping_basket.number_of_licenses
      end
    end
  end
end
