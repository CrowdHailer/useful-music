Customers.create(
  :first_name => 'Peter',
  :last_name => 'Saxton',
  :email => 'peterhsaxton@gmail.com',
  :password => 'asdfghjk',
  :country => Country.new('GB'),
  :admin => true
)


# Bundler.require :test
require 'factory_girl'
FactoryGirl.find_definitions
FactoryGirl.to_create { |i| i.save }

piece_record = FactoryGirl.create :piece_record, :beginner,
  :solo => true,
  :piano => true,
  :flute => true

FactoryGirl.create :item_record,
  :name => 'flute part',
  :piece_record => piece_record,
  :initial_price => Money.new(80),
  :discounted_price => nil,
  :asset => Rack::Test::UploadedFile.new('test/fixtures/UD477fl.pdf', 'application/pdf')

FactoryGirl.create :item_record,
  :name => 'audio',
  :piece_record => piece_record,
  :initial_price => Money.new(100),
  :discounted_price => Money.new(80),
  :asset => Rack::Test::UploadedFile.new('test/fixtures/Ud477.mp3', 'audio/mp3')

FactoryGirl.create :item_record,
  :name => 'all parts',
  :piece_record => piece_record,
  :initial_price => Money.new(350),
  :discounted_price => Money.new(250),
  :asset => Rack::Test::UploadedFile.new('test/fixtures/UD477all.pdf', 'application/pdf')

FactoryGirl.create :item_record,
  :name => 'keyboard',
  :piece_record => piece_record,
  :initial_price => Money.new(100),
  :discounted_price => Money.new(80),
  :asset => Rack::Test::UploadedFile.new('test/fixtures/UD477kbd.pdf', 'application/pdf')
