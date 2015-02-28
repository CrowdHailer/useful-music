require_relative './repository'

class Catalogue < Errol::Repository
  class Page
    def initialize(paginated_dataset)

    end

    # this wraps to an array to surround in entity objects
  end



  # default :title, nil
  # default :levels, []
  # default :page, 1
  # default :page_size, 20

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
    levels = query.levels
    if levels.count > 0
      levels.each_with_index do |level, i|
        val = i == 0 ? val.where(level) : val.or(level)
      end
    end
    val = val.where(:title => query.title) if query.title
    val
  end

  def wrap(record)
    Piece.new(record)
  end

end
