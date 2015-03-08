require_relative './customer'

class Customers < Errol::Repository
  require_relative './customers/inquiry'
  class << self
    def record_class
      Customer::Record
    end

    def inquiry(requirements)
      Inquiry.new(requirements)
    end

    def dispatch(record)
      Customer.new(record)
    end

    def receive(entity)
      entity.record
    end
  end

  def dataset
    raw_dataset
  end
end
