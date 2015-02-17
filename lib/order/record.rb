class Order
  class Record < Sequel::Model(:orders)
    def initialize(*args, &block)
      super
      self.id ||= SecureRandom.uuid()
    end

    # TODO test all
    many_to_one :shopping_basket_record, :class => :'ShoppingBasket::Record', :key => :shopping_basket_id
    many_to_one :customer_record, :class => :'Customer::Record', :key => :customer_id
  end
end
