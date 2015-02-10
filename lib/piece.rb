class Piece
  def initialize(record)
    @record = record
  end

  def title
    record.title
  end

  def title=(title)
    record.title = title
  end

  def catalogue_number
    "UD#{record.id}" if record.id
  end

  def product_name
    "#{title} - #{sub_heading}"
  end

  def record
    @record
  end
end
