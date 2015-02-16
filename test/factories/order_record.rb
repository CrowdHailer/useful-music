require 'factory_girl'

FactoryGirl.define do
  factory :order_record, :class => Order::Record do
    state :something
    shopping_basket_record
    customer_record
  end
end
