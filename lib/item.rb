class Item
  def initialize(record)
    @record = record
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

  def record
    @record
  end
end
