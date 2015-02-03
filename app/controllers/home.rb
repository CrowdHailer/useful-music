class HomeController < UsefulMusic::App
  render_defaults[:dir] << '/home'

  get '/' do
    ap render_defaults.to_s
    render :index
  end
end
