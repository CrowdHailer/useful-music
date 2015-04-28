require_relative './purchase'

class Purchases < Errol::Repository
  require_relative './purchases/inquiry'
  class << self
    def record_class
      Purchase::Record
    end

    def inquiry(requirements)
      Inquiry.new(requirements)
    end

    def dispatch(record)
      Purchase.new(record)
    end

    def receive(entity)
      entity.send :record
    end
  end

  def dataset
    filtered = raw_dataset
    filtered = filtered.where(:shopping_basket_record => inquiry.shopping_basket.record) if inquiry.shopping_basket
    filtered = filtered.where(:item_record => inquiry.item.record) if inquiry.item
    filtered
  end
end
