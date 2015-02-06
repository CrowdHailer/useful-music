require_relative './uploaders/cover_image_uploader'

class Piece
  class Record < Sequel::Model(:pieces)
    unrestrict_primary_key
    plugin :serialization
    # TODO catalogue_number class throw error when providing bad value
    # serialize_attributes [
    #   lambda{|v| v.match(/UD(\d{4})/)[1].to_i},
    #   lambda{|v| "UD%04d" % v}
    # ], :catalogue_number
    mount_uploader :cover_image, CoverImageUploader
  end
end
