require_relative './order'

class Orders < Errol::Repository
  require_relative './orders/inquiry'
  class << self
    def record_class
      Order::Record
    end

    def inquiry(requirements)
      Inquiry.new(requirements)
    end

    def dispatch(record)
      Order.new(record)
    end

    def receive(entity)
      entity.record
    end
  end

  def dataset
    raw_dataset
  end
end
