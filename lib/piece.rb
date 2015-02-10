require_relative './base_entity'

class Piece < BaseEntity
  entry_accessor  :title,
                  :sub_heading,
                  :description,
                  :category,
                  :notation_preview,
                  :audio_preview,
                  :cover_image

  def catalogue_number
    "UD#{record.id}" if record.id
  end

  def product_name
    "#{title} - #{sub_heading}"
  end

end
