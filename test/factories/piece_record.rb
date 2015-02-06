require 'factory_girl'

FactoryGirl.define do
  factory :piece_record, :class => Piece::Record do
    # catalogue_number 'UD0010'
    catalogue_number 10
    title 'A piece of music'
    sub_heading 'flute and claranet'
    description 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
    category 'Solo'
    notation_preview Rack::Multipart::UploadedFile.new 'test/fixtures/UD477sa.pdf', 'image/pdf'
    audio_preview Rack::Multipart::UploadedFile.new 'test/fixtures/UD477sa.mp3', 'audio/mp3'
    cover_image Rack::Multipart::UploadedFile.new 'test/fixtures/UD477.jpg', 'image/jpeg'
  end
end
