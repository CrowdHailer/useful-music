class Discount < Errol::Entity
  require_relative './discount/record'
  entry_accessor  :code,
                  :value,
                  :allocation,
                  :customer_allocation,
                  :start_datetime,
                  :end_datetime
end
