require 'factory_girl'

FactoryGirl.define do
  factory :item_record, :class => Item::Record do
    name 'Flute part'
    initial_price 50
    discounted_price 25
    asset Rack::Test::UploadedFile.new 'test/fixtures/Ud477.mp3', 'audio/mp3'
    piece_record
  end
end
