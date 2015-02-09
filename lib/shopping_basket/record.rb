class ShoppingBasket
  class Record < Sequel::Model(:shopping_baskets)
    one_to_many :purchase_records, :class => :'Purchase::Record', :key => :shopping_basket_id
  end
end
