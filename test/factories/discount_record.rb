require 'factory_girl'

FactoryGirl.define do
  factory :discount_record, :class => Discount::Record do
    code 'ABC'
    value Money.new(1000)
    allocation 10
    customer_allocation 1
    start_datetime DateTime.new(2015, 10, 5)
    end_datetime DateTime.new(2015, 10, 7)
  end
end
