require_relative './discount'

class Discounts < Errol::Repository
  require_relative './discounts/inquiry'
  class << self
    def record_class
      Discount::Record
    end

    def inquiry(requirements)
      Inquiry.new(requirements)
    end

    def dispatch(record)
      Discount.new(record)
    end

    def receive(entity)
      entity.record
    end
  end

  def dataset
    raw_dataset
  end
end
