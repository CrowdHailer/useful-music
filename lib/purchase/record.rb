class Purchase
  class Record < Sequel::Model(:purchases)
    many_to_one :item_record, :class => :'Item::Record', :key => :item_id
  end
end
