require 'factory_girl'

FactoryGirl.define do
  factory :item_record, :class => Item::Record do
    name 'Flute part'
    initial_price 50
    subsequent_price 25
    asset 'download.mp3'
  end
end
