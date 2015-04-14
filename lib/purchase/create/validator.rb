class Purchase
  class Create
    class Validator
      # untested because admin control
      include Veto.validator

      validates :item, :presence => true
      validates :shopping_basket, :not_null => true
      validates :quantity, :greater_than => 0
    end
  end
end
