class Discount < Errol::Entity
  class Null
    def value
      Money.new(0)
    end

    def nil?
      true
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
end
