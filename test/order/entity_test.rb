require_relative '../test_config'

class Order
  class EntityTest < MyRecordTest
    FREE = Money.new(0)
    FIVER = Money.new(500)
    TENNER = Money.new(1000)
    DummyBasket = Struct.new(:purchases_price, :discount_value, :price, :record)

    def order
      @order ||= Order.new record
    end

    def record
      @record ||= OpenStruct.new
    end

    def test_it_should_set_state_to_pending_if_none
      order
      assert_equal 'pending', record.state
    end

    def test_it_should_use_state_if_given
      record.state = 'processing'
      assert_equal 'processing', order.state
    end

    def dummy_customer(vat_rate=0)
      Struct.new(:vat_rate, :record).new(vat_rate, :customer)
    end

    def dummy_basket(purchases_price:, discount_value: FREE)
      DummyBasket.new(purchases_price, discount_value, purchases_price - discount_value, :shopping_basket)
    end

    def test_calculate_payment_no_discount
      order.customer = dummy_customer
      order.shopping_basket = dummy_basket(purchases_price: TENNER)
      order.calculate_payment
      assert_equal TENNER, order.basket_total
      assert_equal Money.new(0), order.discount_value
      assert_equal TENNER, order.payment_gross
      assert_equal Money.new(0), order.tax_payment
      assert_equal TENNER, order.payment_net
    end

    # def test_calculates_payment_with_discount
    #   tenner = Money.new(1000)
    #   fiver = Money.new(500)
    #   order.customer = dummy_customer
    #   order.shopping_basket = dummy_basket(tenner)
    #   order.discount = dummy_discount(fiver)
    #   order.calculate_payment
    #   assert_equal tenner, order.basket_total
    #   assert_equal fiver, order.discount_value
    #   assert_equal fiver, order.payment_gross
    #   assert_equal Money.new(0), order.tax_payment
    #   assert_equal fiver, order.payment_net
    # end
    #
    # def test_calculates_prive_with_big_discount
    #   tenner = Money.new(1000)
    #   fiver = Money.new(500)
    #   order.customer = dummy_customer
    #   order.shopping_basket = dummy_basket(fiver)
    #   order.discount = dummy_discount(tenner)
    #   order.calculate_payment
    #   assert_equal fiver, order.basket_total
    #   assert_equal tenner, order.discount_value
    #   assert_equal Money.new(0), order.payment_gross
    #   assert_equal Money.new(0), order.tax_payment
    #   assert_equal Money.new(0), order.payment_net
    # end
    #
    # def test_calculate_payment_with_vat
    #   tenner = Money.new(1000)
    #   order.customer = dummy_customer(0.2)
    #   order.shopping_basket = dummy_basket(tenner)
    #   order.calculate_payment
    #   assert_equal tenner, order.basket_total
    #   assert_equal Money.new(0), order.discount_value
    #   assert_equal tenner, order.payment_gross
    #   assert_equal Money.new(200), order.tax_payment
    #   assert_equal Money.new(1200), order.payment_net
    # end

    ################# Associations #####################

    def test_can_make_customer
      record.customer_record = :customer
      assert_equal Customer.new(:customer), order.customer
    end

    def test_nil_customer_if_no_record
      assert_nil order.customer
    end

    def test_can_set_customer
      order.customer = Customer.new(:customer)
      assert_equal :customer, record.customer_record
    end

    def test_can_set_nil_customer
      record.customer_record = :customer
      order.customer = nil
    end

    def test_can_make_shopping_basket
      record.shopping_basket_record = :shopping_basket
      assert_equal ShoppingBasket.new(:shopping_basket), order.shopping_basket
    end

    def test_nil_shopping_basket_if_no_record
      assert_nil order.shopping_basket
    end

    def test_can_set_shopping_basket
      order.shopping_basket = ShoppingBasket.new(:shopping_basket)
      assert_equal :shopping_basket, record.shopping_basket_record
    end

    def test_can_set_nil_shopping_basket
      record.shopping_basket_record = :shopping_basket
      order.shopping_basket = nil
    end

    def test_can_make_discount
      record.discount_record = :discount
      assert_equal Discount.new(:discount), order.discount
    end

    def test_nil_discount_if_no_record
      assert_nil order.discount
      assert_equal Money.new(0), order.discount.value
    end

    def test_can_set_discount
      order.discount = Discount.new(:discount)
      assert_equal :discount, record.discount_record
    end

    def test_can_set_nil_discount
      record.discount_record = :discount
      order.discount = nil
    end

    ################# Archive #####################

    def test_can_access_state
      record.state = 'pending'
      assert_equal 'pending', order.state
    end

    def test_can_set_state
      order.state = 'pending'
      assert_equal 'pending', record.state
    end

    def test_can_access_completed_at
      record.completed_at = DateTime.new(2010,4,5)
      assert_equal DateTime.new(2010,4,5), order.completed_at
    end

    def test_can_set_state
      order.completed_at = DateTime.new(2010,4,5)
      assert_equal DateTime.new(2010,4,5), record.completed_at
    end
  end
end
