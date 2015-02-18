class AboutController < UsefulMusic::App
  render_defaults[:dir] += '/about'

  get '/' do
    render :index
  end
end
