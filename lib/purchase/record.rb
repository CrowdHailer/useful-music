class Purchase
  class Record < Sequel::Model(:purchases)
    many_to_one :item_record, :class => :'Item::Record', :key => :item_id
    many_to_one :shopping_basket_record, :class => :'ShoppingBasket::Record', :key => :shopping_basket_id

    def initialize(*args, &block)
      super
      self.id ||= SecureRandom.uuid()
    end
  end
end
