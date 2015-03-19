class Discount < Errol::Entity
  class Null
    def value
      Money.new(0)
    end

    def nil?
      true
    end

    def code
      ''
    end
  end
  def self.null
    Null.new
  end
  require_relative './discount/record'
  entry_accessor  :code,
                  :value,
                  :allocation,
                  :customer_allocation,
                  :start_datetime,
                  :end_datetime

  def expired?
    end_datetime < DateTime.now
  end

  def pending?
    start_datetime > DateTime.now
  end
end
