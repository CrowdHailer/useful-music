class PiecesController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/pieces'

  def index
    render :index
  end

  def new
    render :new
  end

  def create
    form = create_form
    validator = Piece::Create::Validator.new
    # ap validator.valid? form
    # ap form.to_hash

    record = Piece::Record.create form.to_hash
    redirect show_path(record)
  end

  def show_path(piece)
    absolute(piece.catalogue_number.to_s)
  end

  def create_form
    Piece::Create::Form.new request.POST['piece']
  end
end
