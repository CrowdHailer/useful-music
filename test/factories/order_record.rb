require 'factory_girl'

FactoryGirl.define do
  factory :order_record, :class => Order::Record do
    state :pending
    basket_amount Money.new(2)
    tax_amount Money.new(2)
    discount_amount Money.new(2)
    shopping_basket_record
    customer_record
  end
end
