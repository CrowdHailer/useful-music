class PiecesController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/pieces'

  def index
    search = Catalogue::Search.new request.GET.fetch('catalogue_search', {})
    pieces = Catalogue.page search.to_hash
    render :index, :locals => {:pieces => pieces, :search => search}
  end

  def new
    check_access!
    render :new
  end

  def create
    # unvalidated on backend
    check_access!
    piece = Piece.create create_form
    flash['success'] = 'Piece created'
    redirect show_path(piece)
  end

  def show(catalogue_number)
    if @piece = Catalogue[catalogue_number]
      render :show
    else
      flash['error'] = 'Piece not found'
      redirect index_path
    end
  end

  def edit(catalogue_number)
    check_access!
    if @piece = Catalogue[catalogue_number]
      render :edit
    else
      flash['error'] = 'Piece not found'
      redirect index_path
    end
  end

  def update(catalogue_number)
    check_access!
    if piece = Catalogue[catalogue_number]
      form = Piece::Update::Form.new request.POST['piece']
      piece.set! form
      flash['success'] = 'Piece updated'
      redirect show_path(piece)
    else
      flash['error'] = 'Piece not found'
      redirect index_path
    end
  end

  def destroy(catalogue_number)
    check_access!
    if piece = Catalogue[catalogue_number]
      piece.record.destroy
      flash['success'] = 'Piece deleted'
      redirect index_path
    else
      flash['error'] = 'Piece not found'
      redirect index_path
    end
  end

  def show_path(piece)
    File.join(index_path, piece.catalogue_number.to_s)
  end

  def index_path
    # TODO generalise this to scorched rest
    File.join *request.breadcrumb[0...-1].map(&:path)
  end

  def create_form
    Piece::Create::Form.new request.POST['piece']
  end

  def check_access!
    if current_customer.admin?
      true
    else
      flash['error'] = 'Access denied'
      redirect '/'
    end
  end
end
