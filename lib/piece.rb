require_relative './base_entity'

class Piece < BaseEntity
  entry_accessor  :title,
                  :sub_heading,
                  :description,
                  :category,
                  :notation_preview,
                  :audio_preview,
                  :cover_image

  def beginner_level?
    record.beginner_level
  end

  def beginner_level=(bool)
    record.beginner_level = bool
  end

  def intermediate_level?
    record.intermediate_level
  end

  def intermediate_level=(bool)
    record.intermediate_level = bool
  end

  def advanced_level?
    record.advanced_level
  end

  def advanced_level=(bool)
    record.advanced_level = bool
  end

  def professional_level?
    record.professional_level
  end

  def professional_level=(bool)
    record.professional_level = bool
  end

  def catalogue_number
    "UD#{record.id}" if record.id
  end

  def product_name
    "#{title} - #{sub_heading}"
  end

end
