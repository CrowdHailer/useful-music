require_relative '../test_config'

class Order
  class EntityTest < MyRecordTest
    def item
      @item ||= Item.new record
    end

    def record
      @record ||= OpenStruct.new
    end

    def test_creation
      purchase = Purchase.new(create :purchase_record)
      customer = Customer.new(create :customer_record)
      order = Order.create(
        :shopping_basket => purchase.shopping_basket,
        :customer => customer
      ) do |order|
        order.calculate_prices
        order.transaction
      end

      order.setup('http://www.example.com').redirect_uri
    end
  end
end
