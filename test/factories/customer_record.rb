require 'factory_girl'

FactoryGirl.define do
  factory :customer_record, :class => Customer::Record do
    first_name 'Mike'
    last_name 'Wasozki'
    sequence :email do |n|
			"test#{n}@example.com"
		end
    password 'password'
    country Country.new('GB')
    trait :admin do
      admin true
    end
  end
end
