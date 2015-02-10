require_relative './base_entity'

class Piece < BaseEntity
  entry_accessor  :title,
                  :sub_heading,
                  :description

  def category
    record.category
  end

  def category=(category)
    record.category = category
  end

  def catalogue_number
    "UD#{record.id}" if record.id
  end

  def product_name
    "#{title} - #{sub_heading}"
  end

end
