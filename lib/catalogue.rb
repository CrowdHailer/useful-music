

module Catalogue
  class Page
    def initialize(paginated_dataset)

    end

    # this wraps to an array to surround in entity objects
  end

  class Search
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

    def checked?(attribute)
      !!options[attribute.to_s]
    end

  end
  class << self
    def [](catalogue_number)
      id = catalogue_number[/\d+/]
      record = Piece::Record[id]
      Piece.new(record) if record
    end

    def all(query)
      # levels = query_params[:levels]
      # query = Piece::Record.where(levels.pop => true)
      #
      # query_params[:levels].each do |level|
      #   query = query.or(level => true)
      # end
      # Piece::Record.dataset.each_page(1){ |p| ap p.sql}
      # page = Piece::Record.dataset.paginate(1,1)
      # ap page.page_size
      # ap page.page_count
      # ap page.next_page
      # ap page.first_page?
      # ap page.page_range
      # ap page.map(&:class)

      Piece::Record.dataset.paginate(query.page,query.page_size)
    end

  end

end
