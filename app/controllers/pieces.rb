class PiecesController < UsefulMusic::App
  include Scorched::Rest

  render_defaults[:dir] = render_defaults[:dir].clone + '/pieces'

  def index
    render :index
  end

  def new
    'New users'
  end

  def create
    'creating user'
  end

end
