class Order
  class Create
    class Validator
      include Veto.validator
      validates :customer, :presence => true
    end
    class Form
      include Virtus.model
      include Veto.model(Validator.new)
      # def valid?
      #   super
      # end
      #
      # attribute :shopping_basket, Integer
      attribute :customer
      #
      def customer
        Customers[super]
        # Customers.fetch(super) {|id|
        #   ap errors.add(:customer, 'is not present')
        # }
      end
      #
      # def customer=(customer)
      #   @customer = customer
      # end
      #
      # def shopping_basket
      #   ShoppingBasket.new(ShoppingBasket::Record[super])
      # end
      #
      # delegate :each, :to => :to_hash
    end
  end
end
