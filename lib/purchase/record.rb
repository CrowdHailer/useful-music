class Purchase
  class Record < Sequel::Model(:purchases)
    many_to_one :item_record, :class => :'Item::Record', :key => :item_id
    many_to_one :basket_record, :class => :'Basket::Record', :key => :basket_id
  end
end
