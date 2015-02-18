class ShoppingBasket
  class Record < Sequel::Model(:shopping_baskets)
    plugin :timestamps, :update_on_create=>true

    one_to_many :purchase_records, :class => :'Purchase::Record', :key => :shopping_basket_id
    one_to_one :order_record, :class => :'Order::Record', :key => :shopping_basket_id
  end
end
