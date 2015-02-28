module Catalogue
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
      options.fetch('page_size', :id).to_sym
    end

    def title
      options[:title]
    end

  end
  class << self
    def empty?
      Piece::Record.empty?
    end

    def count
      Piece::Record.count
    end

    def all(query_params={})
      query = Query.new query_params
      dataset = Piece::Record
      dataset = dataset.where(:title => query.title) if query.title
      dataset.all.map{ |record| Piece.new record }
    end

    def first
      record = Piece::Record.order(:id).first
      Piece.new(record) if record
    end

    def last
      record = Piece::Record.order(:id).last
      Piece.new(record) if record
    end

    def [](catalogue_number)
      id = catalogue_number[/\d+/]
      record = Piece::Record[id]
      Piece.new(record) if record
    end

    def level(*levels, options)

    end
  end

  def initialize()

  end

end
