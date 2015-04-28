require_relative './shopping_basket'

class ShoppingBaskets < Errol::Repository
  require_relative './shopping_baskets/inquiry'
  class << self
    def save(entity)
      entity.modifiable!
      super
    end

    def record_class
      ShoppingBasket::Record
    end

    def inquiry(requirements)
      Inquiry.new(requirements)
    end

    def dispatch(record)
      ShoppingBasket.new(record)
    end

    def receive(entity)
      entity.send :record
    end

    def inactive(options={})
      cutoff = options.fetch(:since) { DateTime.now }
      all.select{|b| b.orders.empty? && b.customer.nil? && b.last_revision_at < cutoff}
    end

    def clear_inactive(options={})
      inactive(options).each do |basket|
        remove basket
      end
    end
  end

  def dataset
    tmp = raw_dataset
    if inquiry.checked_out
      # ap Orders.new(:paginate => false, :succeded => true).dataset.sql
      tmp = tmp.where(:order_records => Orders.new(:paginate => false, :succeded => true).dataset)
    end
    if inquiry.discount
      tmp = tmp.where(:discount_record => inquiry.discount.record)
    end
    tmp
  end
end
