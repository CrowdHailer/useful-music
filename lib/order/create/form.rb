class Order
  class Create
    class Form
      include Virtus.model

      attribute :shopping_basket, Integer
      attribute :customer

      def customer
        @customer
      end

      def customer=(customer)
        @customer = customer
      end

      def shopping_basket
        ShoppingBasket.new(ShoppingBasket::Record[super])
      end

      delegate :each, :to => :to_hash
    end
  end
end
