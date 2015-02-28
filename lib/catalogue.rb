require_relative './repository'

class Catalogue < Errol::Repository
  class Page
    def initialize(paginated_dataset)

    end

    # this wraps to an array to surround in entity objects
  end

  class << self

    def [](catalogue_number)
      super catalogue_number[/\d+/]
    end

    def level(*level, options)

    end
  end

  def wrap(record)
    Piece.new(record)
  end

end
