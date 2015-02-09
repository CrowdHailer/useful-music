class Item
  def initialize(record)
    @record = record
  end

  def initial_price
    record.initial_price
  end

  def subsequent_price
    record.subsequent_price || record.initial_price
  end

  def record
    @record
  end
end
