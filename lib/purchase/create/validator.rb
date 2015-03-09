class Purchase
  class Create
    class Validator
      # TODO untested because admin control
      include Veto.validator

      validates :item, :presence => true
      validates :shopping_basket, :presence => true
      validates :quantity, :greater_than => 0 
    end
  end
end
