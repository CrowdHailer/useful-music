class Catalogue < Errol::Repository
  def inquiry(requirements)
    Inquiry.new requirements
  end

  def dispatch(record)
    Piece.new record
  end

  def receive(piece)
    piece.record
  end

  def dataset
    tmp = DB['pieces']
    categories.each_with_index do |category, i|
      tmp = i == 0 ? val.where(category) : val.or(category)
    end
  end

  # def filter_categories(categories, dataset)
  #   inquiry.categories.reduce(dataset){ |dataset| }
  # end

end
