require_relative './errol/repository'
require_relative './piece'

class Catalogue < Errol::Repository
  require_relative './catalogue/query'
  require_relative './catalogue/search'

  query_class Query
  record_class ::Piece::Record

  class << self

    def [](catalogue_number)
      super catalogue_number[/\d+/]
    end

    def levels(*levels, **options)
      all options.merge(:levels => levels)
    end
  end


  def dataset
    val = super
    val = val.order(query.order.to_sym)

    # val = levels_filter(val) if levels.count > 0
    levels = query.levels
    if levels.count > 0
      levels.each_with_index do |level, i|
        val = i == 0 ? val.where(level) : val.or(level)
      end
    end

    categories = query.categories
    if categories.count > 0
      categories.each_with_index do |category, i|
        val = i == 0 ? val.where(category) : val.or(category)
      end
    end

    instruments = query.instruments
    if instruments.count > 0
      instruments.each_with_index do |instrument, i|
        val = i == 0 ? val.where(instrument) : val.or(instrument)
      end
    end

    val = val.where(:title => query.title) if query.title
    val
  end

  def implant(record)
    Piece.new(record)
  end

  def extract

  end

end
