require 'factory_girl'

FactoryGirl.define do
  factory :order_record, :class => Order::Record do
    state :pending
    basket_total Money.new(1000)
    tax_payment Money.new(200)
    discount_value Money.new(0)
    payment_gross Money.new(1000)
    payment_net Money.new(1200)
    currency Money::Currency.new('GBP')
    shopping_basket_record
    customer_record
  end
end
