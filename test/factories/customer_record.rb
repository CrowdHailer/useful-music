require 'factory_girl'

FactoryGirl.define do
  factory :customer_record, :class => Customer::Record do
    first_name 'Mike'
    last_name 'Wasozki'
    email 'test@example.com'
    password 'password'
    country Country.new('GB')
  end
end
