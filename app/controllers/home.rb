class HomeController < UsefulMusic::App
  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/home'

  get '/' do
    render :index
  end

  get '/my-shopping-basket' do
    if session['useful_music.basket_id']
      basket = ShoppingBasket::Record[session['useful_music.basket_id']]
    else
      basket = ShoppingBasket::Record.create
      session['useful_music.basket_id'] = basket.id
    end
    redirect "/basket/#{basket.id}"
    # TODO move logic from this controller. redirect to new or show route
  end

  get '/b' do
    raise StandardError
  end

  get '/secure' do
    ap 'hello'
    env['warden'].authenticate!
  end

  get '/unauthenticated' do
    ap 'x'
    ap env['warden.options']
  end

end
