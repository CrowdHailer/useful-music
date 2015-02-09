class BasketController < UsefulMusic::App
  # NOTE: need to create new string to assign in config dir
  # render_defaults[:dir] += '/home'

  # get '/' do
  #   render :index
  # end

  post '/add_purchases' do
    ap add_form.to_s
  end

  def add_form
     request.POST['purchases']
  end
end
