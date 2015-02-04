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

  def show(id)
    # expose(:piece => Piece::Cartridge[id])
    expose_piece Piece::Cartridge[id]
    render :show
  end

  def edit(id)
    expose_piece Piece::Cartridge[id]
    render :edit
  end

  post '/:id/edit' do |id|
    piece = Piece::Cartridge[id].update request.POST['piece']
    redirect "/pieces/#{piece.id}"
  end

  def update(id)
    'dd'

  end

  def expose(items)
    locals.merge! items
  end

  def locals
    @locals ||= {}
  end

  def render(template, options={})
    super(template, options.merge(:locals => locals))
  end

  def method_missing(name, *args, &block)
    if match = /(?:expose_)(?<local>.+)/.match(name)
      send :expose, match[:local].to_sym => args[0]
    else
      super
    end
  end
end
