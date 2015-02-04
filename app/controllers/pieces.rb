class PiecesController < UsefulMusic::App
  include Scorched::Rest

  render_defaults[:dir] = render_defaults[:dir].clone + '/pieces'

  def index
    @pieces = Piece::Cartridge.all
    render :index
  end

  def new
    @piece = Piece.new
    render :new
  end

  def create
    Piece::Cartridge.create request.POST['piece']
    redirect '/pieces'
  end

end
