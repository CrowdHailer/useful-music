class HomeController < UsefulMusic::App
  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/home'

  get '/' do
    render :index
  end

  post '/currency' do
    currency = request.POST['preference']
    current_customer.currency_preference = currency if ['USD', 'GBP', 'EUR'].include?(currency)
    redirect request.referer
  end

  get '/my-shopping-basket' do
    # TODO test
    redirect "/shopping_baskets/#{live_shopping_basket_id}"
  end

  get '/piano' do
    redirect '/pieces?catalogue_search[piano]=on'
  end

  get '/woodwind' do
    redirect '/pieces?catalogue_search%5Brecorder%5D=on&catalogue_search%5Bflute%5D=on&catalogue_search%5Boboe%5D=on&catalogue_search%5Bclarineo%5D=on&catalogue_search%5Bclarinet%5D=on&catalogue_search%5Bbasson%5D=on&catalogue_search%5Bsaxophone%5D=on&catalogue_search%5Bpage_size%5D=10'
  end

  get '/recorder' do
    redirect '/pieces?catalogue_search[recorder]=on'
  end

  get '/flute' do
    redirect '/pieces?catalogue_search[flute]=on'
  end

  get '/oboe' do
    redirect '/pieces?catalogue_search[oboe]=on'
  end

  get '/clarineo' do
    redirect '/pieces?catalogue_search[clarineo]=on'
  end

  get '/clarinet' do
    redirect '/pieces?catalogue_search[clarinet]=on'
  end

  get '/bassoon' do
    redirect '/pieces?catalogue_search[basson]=on'
  end

  get '/saxophone' do
    redirect '/pieces?catalogue_search[saxophone]=on'
  end

  get '/trumpet' do
    redirect '/pieces?catalogue_search[trumpet]=on'
  end

  get '/violin' do
    redirect '/pieces?catalogue_search[violin]=on'
  end

  get '/viola' do
    redirect '/pieces?catalogue_search[viola]=on'
  end

  get '/percussion' do
    redirect '/pieces?catalogue_search[percussion]=on'
  end

  get '/solo' do
    redirect '/pieces?catalogue_search[solo]=on'
  end

  get '/solo_with_accompaniment' do
    redirect '/pieces?catalogue_search[solo_with_accompaniment]=on'
  end

  get '/duet' do
    redirect '/pieces?catalogue_search[duet]=on'
  end

  get '/trio' do
    redirect '/pieces?catalogue_search[trio]=on'
  end

  get '/quartet' do
    redirect '/pieces?catalogue_search[quartet]=on'
  end

  get '/larger_ensembles' do
    redirect '/pieces?catalogue_search[larger_ensembles]=on'
  end

end
