Dir[File.expand_path('../**/*.rb', __FILE__)].each { |file| require file }

class Purchase
  class Record < Sequel::Model(:purchases)
    many_to_one :item_record, :class => :'Item::Record', :key => :item_id
    many_to_one :shopping_basket_record, :class => :'ShoppingBasket::Record', :key => :shopping_basket_id

    plugin :timestamps, :update_on_create=>true

    def initialize(*args, &block)
      super
      self.id ||= SecureRandom.uuid()
    end
  end
end
