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

  get '/piano' do
    # TODO test
    redirect '/pieces?catalogue_search[piano]=on'
  end

  get '/woodwind' do
    # TODO test
    redirect 'http://localhost:9393/pieces?catalogue_search%5Brecorder%5D=on&catalogue_search%5Bflute%5D=on&catalogue_search%5Boboe%5D=on&catalogue_search%5Bclarineo%5D=on&catalogue_search%5Bclarinet%5D=on&catalogue_search%5Bbasson%5D=on&catalogue_search%5Bsaxophone%5D=on&catalogue_search%5Bpage_size%5D=10'
  end

  get '/trouble' do
    raise RuntimeError, 'jazzt'
  end

  error RuntimeError do
    ap Bugsnag.notify($!)
    ap 'x'
  end

  after status: 500 do
    ap 'ey'
  end
end
