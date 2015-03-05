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

  def new
    check_access!
    render :new
  end

  def create
    begin
      check_access!
      form = Piece::Create::Form.new request.POST['piece']
      piece = Piece.create form
      flash['success'] = 'Piece created'
      redirect show_path(piece)
    rescue Sequel::UniqueConstraintViolation => err
      flash['error'] = 'Piece UD#{form.id} already exists and may be edited'
      redirect "/pieces/UD#{form.id}/edit"
    rescue Sequel::NotNullConstraintViolation => err
      Bugsnag.notify(err)
      flash['error'] = 'Could not create invalid piece'
      redirect '/pieces/new'
    end
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

  def check_access!
    if current_customer.admin?
      true
    else
      flash['error'] = 'Access denied'
      redirect '/'
    end
  end
end
