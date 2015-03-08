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

    def authenticate(email, password)
      customer = new(:email => email).first
      return false unless customer && customer.authenticate(password)
      customer
    end
  end

  def dataset
    inquiry.email? ? raw_dataset.where(:email => inquiry.email) : raw_dataset
  end
end
