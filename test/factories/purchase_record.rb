require 'factory_girl'

FactoryGirl.define do
  factory :purchase_record, :class => Purchase::Record do
    quantity 2
    item_record
    shopping_basket_record
  end
end
