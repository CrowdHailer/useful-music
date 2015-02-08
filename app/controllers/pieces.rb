class PiecesController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/pieces'

  def index
    @pieces = Piece::Record.all
    render :index
  end

  def new
    render :new
  end

  def create
    form = create_form
    validator = Piece::Create::Validator.new

    record = Piece::Record.create form.to_hash
    redirect show_path(record)
  end

  def show(id)
    @piece = Piece::Record[id]
    render :show
  end

  def destroy(id)
    Piece::Record[id].destroy
    redirect '/pieces'
  end

  def show_path(piece)
    File.join(controller_path, piece.catalogue_number.to_s)
  end

  def controller_path
    File.join *request.breadcrumb[0...-1].map(&:path)
  end

  def create_form
    Piece::Create::Form.new request.POST['piece']
  end
end
