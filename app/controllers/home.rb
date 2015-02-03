class HomeController < UsefulMusic::App
  render_defaults[:dir] << '/home'

  get '/' do
    render :index
  end
end
