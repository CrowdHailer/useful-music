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

  def sub_heading
    record.sub_heading
  end

  def sub_heading=(sub_heading)
    record.sub_heading = sub_heading
  end

  def description
    record.description
  end

  def description=(description)
    record.description = description
  end

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

  def record
    @record
  end
end
