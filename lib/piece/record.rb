require_relative './uploaders/cover_image_uploader'
require_relative './uploaders/audio_preview_uploader'
require_relative './uploaders/notation_preview_uploader'

class Piece
  class Record < Sequel::Model(:pieces)
    unrestrict_primary_key

    one_to_many :item_records, :class => :'Item::Record', :key => :piece_id

    plugin :association_dependencies, :item_records => :delete

    plugin :serialization
    mount_uploader :cover_image, CoverImageUploader
    mount_uploader :audio_preview, AudioPreviewUploader
    mount_uploader :notation_preview, NotationPreviewUploader

  end
end
