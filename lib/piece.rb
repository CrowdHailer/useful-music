class Piece < SimpleDelegator
  # def initialize(record)
  #   @record = record
  # end

  def catalogue_number
    "UD#{record.id}" if record.id
  end

  def product_name
    "#{title} - #{sub_heading}"
  end

  def record
    @record
    __getobj__
  end
end
