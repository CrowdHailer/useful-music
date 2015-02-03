class PiecesController < UsefulMusic::App
  include Scorched::Rest

  render_defaults[:dir] = render_defaults[:dir].clone + '/pieces'

  def index
    render :index
  end

  def new
    render :new
  end

  def create
    'creating user'
  end

end
