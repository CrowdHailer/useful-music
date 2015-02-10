class Item
  def initialize(record)
    @record = record
  end

  def piece
    Piece.new record.piece_record if record.piece_record
  end

  def piece=(piece)
    record.piece_record = piece.record
  end

  def name
    record.name
  end

  def name=(name)
    record.name = name
  end

  def initial_price
    record.initial_price
  end

  def initial_price=(initial_price)
    record.initial_price = initial_price
  end

  def subsequent_price
    record.subsequent_price || record.initial_price
  end

  def subsequent_price=(subsequent_price)
    record.subsequent_price = subsequent_price
  end

  def asset
    record.asset
  end

  def asset=(asset)
    record.asset = asset
  end

  def record
    @record
  end
end
