class ShoppingBasket
  class Record < Sequel::Model(:shopping_baskets)
    def initialize(*args, &block)
      super
      self.id ||= SecureRandom.urlsafe_base64
    end

    plugin :timestamps, :update_on_create=>true

    one_to_many :purchase_records, :class => :'Purchase::Record', :key => :shopping_basket_id
    one_to_one :order_record, :class => :'Order::Record', :key => :shopping_basket_id

    plugin :association_dependencies, :purchase_records => :delete
  end
end
