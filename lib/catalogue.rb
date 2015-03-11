require_relative './piece'

class Catalogue < Errol::Repository
  require_relative './catalogue/inquiry'
  require_relative './catalogue/search'

  class << self
    def record_class
      Piece::Record
    end

    def inquiry(requirements)
      Inquiry.new(requirements)
    end

    def dispatch(record)
      Piece.new(record)
    end

    def receive(entity)
      entity.record
    end

    def levels(*levels, **options)
      all options.merge(:levels => levels)
    end
  end

  def [](catalogue_number)
    super catalogue_number[/\d+/]
  end

  def dataset
    val = raw_dataset
    order = inquiry.order.to_sym
    if order == :random
      val = val.order(Sequel.lit('RANDOM()'))
    else
      val = val.order(inquiry.order.to_sym)
    end

    # val = levels_filter(val) if levels.count > 0
    levels = inquiry.levels
    if levels.count > 0
      levels.each_with_index do |level, i|
        val = i == 0 ? val.where(level) : val.or(level)
      end
    end

    categories = inquiry.categories
    if categories.count > 0
      categories.each_with_index do |category, i|
        val = i == 0 ? val.where(category) : val.or(category)
      end
    end

    instruments = inquiry.instruments
    if instruments.count > 0
      instruments.each_with_index do |instrument, i|
        val = i == 0 ? val.where(instrument) : val.or(instrument)
      end
    end

    val = val.where(:title => inquiry.title) if inquiry.title
    val
  end

end
