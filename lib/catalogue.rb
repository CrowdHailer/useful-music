require_relative './repository'

class Catalogue < Errol::Repository
  class Page
    def initialize(paginated_dataset)

    end

    # this wraps to an array to surround in entity objects
  end

  class Query
    def initialize(options={})
      @options = options
    end

    attr_accessor :options

    def page
      options.fetch('page', 1).to_i
    end

    def page_size
      options.fetch('page_size', 3).to_i
    end

    def order
      options.fetch(:order, :id).to_sym
    end

    def title
      options[:title]
    end

    def levels
      options.fetch(:levels, [])
    end

  end

  class << self

    def [](catalogue_number)
      super catalogue_number[/\d+/]
    end

    def level(*level, options)

    end
  end

  def initialize(query_params={})
    query = Query.new query_params
    dataset = Piece::Record
    dataset = dataset.order(query.order)
    levels = query.levels
    if levels.count > 0
      levels.each_with_index do |level, i|
        dataset = i == 0 ? dataset.where(level) : dataset.or(level)
      end
    end
    dataset = dataset.where(:title => query.title) if query.title
    @dataset = dataset
  end

  def wrap(record)
    Piece.new(record)
  end

end
