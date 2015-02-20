Customer.create(
  :first_name => 'Peter',
  :last_name => 'Saxton',
  :email => 'peterhsaxton@gmail.com',
  :password => 'asdfghjk',
  :country => 'GB'
)

Customer.create(
  :first_name => 'Daisy',
  :last_name => 'Hill',
  :email => 'daisy@usefulmusic.com',
  :password => 'asdfghjk',
  :country => 'GB'
)

Bundler.require :test
require 'factory_girl'
FactoryGirl.find_definitions
FactoryGirl.to_create { |i| i.save }

5.times{ FactoryGirl.create :piece_record }
5.times{ FactoryGirl.create :piece_record, :intermediate, :advanced}
