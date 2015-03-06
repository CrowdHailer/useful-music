class PiecesController < UsefulMusic::App
  get('/search') { send :search }
  include Scorched::Rest

  render_defaults[:dir] += '/pieces'

  def index
    @search = Catalogue::Search.new request.GET.fetch('catalogue_search', {})
    @pieces = Catalogue.new @search
    render :index
  end

  def search
    piece = Catalogue[request.GET.fetch('search') { '' }]
    if piece
      redirect "/pieces/#{piece.catalogue_number}"
    else
      flash['error'] = 'Could not find piece requested'
      redirect(request.referer || '/pieces')
    end
  end

  def show(catalogue_number)
    @piece = Catalogue.fetch(catalogue_number, &method(:piece_not_found))
    render :show
  end

  def edit(catalogue_number)
    check_admin!
    @piece = Catalogue.fetch(catalogue_number, &method(:piece_not_found))
    render :edit
  end

  def update(catalogue_number)
    check_admin!
    piece = Catalogue.fetch(catalogue_number, &method(:piece_not_found))
    form = Piece::Update::Form.new request.POST['piece']
    piece.set! form
    flash['success'] = 'Piece updated'
    redirect show_path(piece)
  end

  def destroy(catalogue_number)
    check_admin!
    piece = Catalogue.fetch(catalogue_number, &method(:piece_not_found))
    piece.record.destroy
    flash['success'] = 'Piece deleted'
    redirect index_path
  end

  def piece_not_found(id)
    flash['error'] = 'Piece not found'
    redirect index_path
  end

  def show_path(piece)
    File.join(index_path, piece.catalogue_number.to_s)
  end

  def index_path
    # TODO generalise this to scorched rest
    File.join *request.breadcrumb[0...-1].map(&:path)
  end

  def check_admin!
    current_customer.admin? || deny_access
  end

end
