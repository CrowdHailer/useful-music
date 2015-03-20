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
      entity.record
    end
  end

  def dataset
    raw_dataset
  end
end
