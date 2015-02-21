
module Catalogue
  extend self

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
