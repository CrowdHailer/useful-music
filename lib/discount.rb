require_relative './errol/entity'

class Discount < Errol::Entity
  entry_accessor  :code,
                  :value,
                  :allocation,
                  :customer_allocation,
                  :start_datetime,
                  :end_datetime
end
