class ItemsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/items'

  def new
    piece_id = request.GET.fetch('piece_id')
    @piece_record = Piece::Record[piece_id]
    render :new
  end
end
