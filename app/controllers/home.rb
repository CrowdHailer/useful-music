class HomeController < UsefulMusic::App
  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/home'

  get '/' do
    render :index
  end

  get '/my-shopping-basket' do
    # TODO test
    redirect "/shopping_baskets/#{live_shopping_basket_id}"
  end
end
