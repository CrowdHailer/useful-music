class Catalogue
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

  end
  class << self
    def empty?(query_params={})
      new(query_params).empty?
    end

    def count(query_params={})
      new(query_params).count
    end

    def all(query_params={})
      new(query_params).all
    end

    def first(query_params={})
      new(query_params).first
    end

    def last(query_params={})
      new(query_params).last
    end

    def [](catalogue_number)
      id = catalogue_number[/\d+/]
      record = Piece::Record[id]
      Piece.new(record) if record
    end

    def level(*levels, options)

    end
  end

  def initialize(query_params={})
    query = Query.new query_params
    dataset = Piece::Record
    dataset = dataset.order(query.order)
    dataset = dataset.where(:title => query.title) if query.title
    @dataset = dataset
  end

  def empty?
    @dataset.empty?
  end

  def count
    @dataset.count
  end

  def all
    @dataset.map(&Piece.method(:new))
  end

  def first
    record = @dataset.first
    Piece.new(record) if record
  end

  def last
    record = @dataset.last
    Piece.new(record) if record
  end

end
