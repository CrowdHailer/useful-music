class PiecesController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/pieces'

  def index
    ap request.GET['catalogue_search']
    pieces = Piece::Record.all
    render :index, :locals => {:pieces => pieces}
  end

  def new
    render :new
  end

  def create
    form = create_form.to_hash
    validator = Piece::Create::Validator.new

    record = Piece::Record.create form
    piece = Piece.new record
    redirect show_path(piece)
  end

  def show(catalogue_number)
    id = catalogue_number[/\d+/]
    if record = Piece::Record[id]
      @piece = Piece.new(record)
      render :show
    else
      redirect index_path
    end
  end

  def edit(catalogue_number)
    id = catalogue_number[/\d+/]
    if record = Piece::Record[id]
      @piece = Piece.new(record)
      render :edit
    else
      redirect index_path
    end
  end

  def update(catalogue_number)
    id = catalogue_number[/\d+/]
    if record = Piece::Record[id]
      form = Piece::Update::Form.new request.POST['piece']
      record.update form.to_hash
      piece = Piece.new(record)
      redirect show_path(piece)
    else
      redirect index_path
    end
  end

  def destroy(catalogue_number)
    id = catalogue_number[/\d+/]
    Piece::Record[id].destroy
    redirect index_path
  end

  def show_path(piece)
    File.join(index_path, piece.catalogue_number.to_s)
  end

  def index_path
    File.join *request.breadcrumb[0...-1].map(&:path)
  end

  def create_form
    Piece::Create::Form.new request.POST['piece']
  end
end
