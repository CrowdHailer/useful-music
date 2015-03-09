require_relative './item'

class Items < Errol::Repository
  # require_relative './items/inquiry'
  class << self
    def record_class
      Item::Record
    end

    def inquiry(requirements)
      Inquiry.new(requirements)
    end

    def dispatch(record)
      Item.new(record)
    end

    def receive(entity)
      entity.record
    end
  end

  def dataset
    raw_dataset
  end
end
