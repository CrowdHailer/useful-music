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

    def available(code)
      first(:code => code, :available => true)
    end
  end

  def dataset
    tmp = raw_dataset
    if inquiry.available == true
      tmp = tmp.where{start_datetime < DateTime.now}.where{end_datetime > DateTime.now}
    end
    if inquiry.code
      tmp = tmp.where(:code => inquiry.code)
    end
    tmp
  end
end
