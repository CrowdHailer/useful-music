class Piece
  def initialize(record)
    @record = record
  end

  def catalogue_number
    "UD#{record.id}" if record.id
  end

  def record
    @record
  end
end
