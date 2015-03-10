class HomeController < UsefulMusic::App
  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/home'

  get '/' do
    render :index
  end

  post '/currency' do
    Guest.new(session).currency_preference = request.POST['preference']
    redirect request.referer
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
    redirect '/pieces?catalogue_search%5Brecorder%5D=on&catalogue_search%5Bflute%5D=on&catalogue_search%5Boboe%5D=on&catalogue_search%5Bclarineo%5D=on&catalogue_search%5Bclarinet%5D=on&catalogue_search%5Bbasson%5D=on&catalogue_search%5Bsaxophone%5D=on&catalogue_search%5Bpage_size%5D=10'
  end

  get '/recorder' do
    # TODO test
    redirect '/pieces?catalogue_search[recorder]=on'
  end

  get '/flute' do
    # TODO test
    redirect '/pieces?catalogue_search[flute]=on'
  end

  get '/oboe' do
    # TODO test
    redirect '/pieces?catalogue_search[oboe]=on'
  end

  get '/clarineo' do
    # TODO test
    redirect '/pieces?catalogue_search[clarineo]=on'
  end

  get '/clarinet' do
    # TODO test
    redirect '/pieces?catalogue_search[clarinet]=on'
  end

  get '/bassoon' do
    # TODO test
    redirect '/pieces?catalogue_search[basson]=on'
  end

  get '/saxophone' do
    # TODO test
    redirect '/pieces?catalogue_search[saxophone]=on'
  end

  get '/trumpet' do
    # TODO test
    redirect '/pieces?catalogue_search[trumpet]=on'
  end

  get '/violin' do
    # TODO test
    redirect '/pieces?catalogue_search[violin]=on'
  end

  get '/viola' do
    # TODO test
    redirect '/pieces?catalogue_search[viola]=on'
  end

  get '/percussion' do
    # TODO test
    redirect '/pieces?catalogue_search[percussion]=on'
  end

  get '/solo' do
    # TODO test
    redirect '/pieces?catalogue_search[solo]=on'
  end

  get '/solo_with_accompaniment' do
    # TODO test
    redirect '/pieces?catalogue_search[solo_with_accompaniment]=on'
  end

  get '/duet' do
    # TODO test
    redirect '/pieces?catalogue_search[duet]=on'
  end

  get '/trio' do
    # TODO test
    redirect '/pieces?catalogue_search[trio]=on'
  end

  get '/quartet' do
    # TODO test
    redirect '/pieces?catalogue_search[quartet]=on'
  end

  get '/larger_ensembles' do
    # TODO test
    redirect '/pieces?catalogue_search[larger_ensembles]=on'
  end

end
