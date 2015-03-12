require_relative '../test_config'

class Order
  class EntityTest < MyRecordTest
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

    # def test_creation
    #   purchase = Purchase.new(create :purchase_record)
    #   customer = Customer.new(create :customer_record)
    #   order = Order.create(
    #     :shopping_basket => purchase.shopping_basket,
    #     :customer => customer
    #   ) do |order|
    #     order.calculate_prices
    #     order.transaction
    #   end
    #
    #   order.setup('http://www.example.com').redirect_uri
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

    def test_can_initialize_with_customer
      order = Order.new :customer => Customer.new(:customer)
      assert_equal :customer, order.customer.record
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

    def test_can_set_first_name
      order.state = 'pending'
      assert_equal 'pending', record.state
    end
  end
end
