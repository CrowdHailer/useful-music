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
    form = create_form.to_hash
    items = form.delete(:items)
    validator = Piece::Create::Validator.new

    record = Piece::Record.create form
    items.each do |item|
      record.add_item_record item
    end
    redirect show_path(record)
  end

  def show(id)
    if @piece = Piece::Record[id]
      render :show
    else
      redirect index_path
    end
  end

  def destroy(id)
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
