require_relative './base_entity'

class Piece < BaseEntity
  entry_accessor  :title,
                  :sub_heading,
                  :description,
                  :category,
                  :notation_preview,
                  :audio_preview,
                  :cover_image,
                  :meta_description,
                  :meta_keywords

  def items
    record.item_records.map{ |r| Item.new r }
  end

  def beginner?
    record.beginner
  end

  def beginner=(bool)
    record.beginner = bool
  end

  def intermediate?
    record.intermediate
  end

  def intermediate=(bool)
    record.intermediate = bool
  end

  def advanced?
    record.advanced
  end

  def advanced=(bool)
    record.advanced = bool
  end

  def professional?
    record.professional
  end

  def professional=(bool)
    record.professional = bool
  end

  def piano?
    record.piano
  end

  def piano=(bool)
    record.piano = bool
  end

  def catalogue_number
    "UD#{record.id}" if record.id
  end

  def product_name
    "#{title} - #{sub_heading}"
  end

end
