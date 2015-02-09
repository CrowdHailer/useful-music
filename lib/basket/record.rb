class Basket
  class Record < Sequel::Model(:baskets)
    one_to_many :purchase_records, :class => :'Purchase::Record', :key => :basket_id
  end
end
