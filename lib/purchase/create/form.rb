class Purchase
  class Create
    require_relative './validator'
    class Form
      include Virtus.model
      include Veto.model(Validator.new)
      attribute :quantity, Integer
      attribute :item, String
      attribute :shopping_basket, String

      def quantity
        coerced = super
        coerced.is_a?(Integer) ? coerced : 0
      end

      def item
        Items[super]
      end

      def shopping_basket
        ShoppingBaskets[super]
      end

      def empty?
        quantity == 0
      end

      delegate :each, :to => :to_hash

    end
  end
end
