class Purchase
  class Create
    class Form
      include Virtus.model
      attribute :quantity, Integer
      attribute :item, Integer
      attribute :shopping_basket, String
      delegate :each, :to => :to_hash

      def item
        Item.new(Item::Record[super])
      end

      def shopping_basket
        ShoppingBasket.new(ShoppingBasket::Record[super])
      end
    end
  end

  class CreateMany
    class Form
      include Virtus.model
      attribute :purchases, Array[Create::Form]

    end
  end
end
