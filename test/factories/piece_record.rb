require 'factory_girl'

FactoryGirl.define do
  factory :piece_record, :class => Piece::Record do
    # catalogue_number 'UD0010'
    sequence(:id, 100)
    title 'A piece of music'
    sub_heading 'flute and claranet'
    level_overview '1 to 3'
    description 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
    notation_preview Rack::Test::UploadedFile.new 'test/fixtures/UD477sa.pdf', 'application/pdf'
    audio_preview Rack::Test::UploadedFile.new 'test/fixtures/UD477sa.mp3', 'audio/mp3'
    cover_image Rack::Test::UploadedFile.new 'test/fixtures/UD477.jpg', 'image/jpeg'
    trait :beginner do
      beginner true
    end
    trait :intermediate do
      intermediate true
    end
    trait :advanced do
      advanced true
    end
    trait :professional do
      professional true
    end
    trait :solo do
      solo true
    end
    trait :duet do
      duet true
    end
    trait :trio do
      trio true
    end
    trait :piano do
      piano true
    end
    trait :recorder do
      recorder true
    end
    trait :flute do
      flute true
    end
    trait :meta_data do
      meta_description 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
      meta_keywords 'Some Key Words'
    end
  end
end
