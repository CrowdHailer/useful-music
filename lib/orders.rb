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
    tmp = raw_dataset
    if inquiry.succeded
      tmp = tmp.where(:state => 'succeded')
    end
    if inquiry.customer
      tmp = tmp.where(:customer_record => inquiry.customer.record)
    end
    if inquiry.discount
      tmp = tmp.where(:discount_record => inquiry.discount.record)
    end
    tmp
  end
end
