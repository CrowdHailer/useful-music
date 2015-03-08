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
      entity.record
    end
  end

  def dataset
    raw_dataset
  end
end
