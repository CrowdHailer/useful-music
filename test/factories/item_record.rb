require 'factory_girl'

FactoryGirl.define do
  factory :item_record, :class => Item::Record do
    name 'Flute part'
    initial_price Money.new(50)
    discounted_price Money.new(25)
    asset Rack::Test::UploadedFile.new 'test/fixtures/Ud477.mp3', 'audio/mp3'
    piece_record
  end
end
