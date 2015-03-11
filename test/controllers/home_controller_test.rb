require_relative '../test_config'

class HomeControllerTest < MyRecordTest
  include ControllerTesting

  def app
    HomeController
  end

  def test_sets_currency
    post '/currency', {:preference => 'USD'}
    assert_equal 'USD', last_request.session['guest.currency_preference']
  end

  def test_doesnt_set_unkown_currency
    post '/currency', {:preference => 'ZZZ'}
    assert_equal nil, last_request.session['guest.currency_preference']
  end

  def test_home_page_is_available
    create :piece_record
    assert_ok get '/'
  end

  def test_redirects_to_piano_search
    get '/piano'
    assert last_response.redirect?
  end

  def test_redirects_to_woodwind_search
    get '/woodwind'
    assert last_response.redirect?
  end

  def test_redirects_to_recorder_search
    get '/recorder'
    assert last_response.redirect?
  end

  def test_redirects_to_flute_search
    get '/flute'
    assert last_response.redirect?
  end

  def test_redirects_to_oboe_search
    get '/oboe'
    assert last_response.redirect?
  end

  def test_redirects_to_clarineo_search
    get '/clarineo'
    assert last_response.redirect?
  end

  def test_redirects_to_clarinet_search
    get '/clarinet'
    assert last_response.redirect?
  end

  def test_redirects_to_bassoon_search
    get '/bassoon'
    assert last_response.redirect?
  end

  def test_redirects_to_saxophone_search
    get '/saxophone'
    assert last_response.redirect?
  end

  def test_redirects_to_trumpet_search
    get '/trumpet'
    assert last_response.redirect?
  end

  def test_redirects_to_violin_search
    get '/violin'
    assert last_response.redirect?
  end

  def test_redirects_to_viola_search
    get '/viola'
    assert last_response.redirect?
  end

  def test_redirects_to_percussion_search
    get '/percussion'
    assert last_response.redirect?
  end

  def test_redirects_to_solo_search
    get '/solo'
    assert last_response.redirect?
  end

  def test_redirects_to_solo_with_accompaniment_search
    get '/solo_with_accompaniment'
    assert last_response.redirect?
  end

  def test_redirects_to_duet_search
    get '/duet'
    assert last_response.redirect?
  end

  def test_redirects_to_trio_search
    get '/trio'
    assert last_response.redirect?
  end

  def test_redirects_to_quartet_search
    get '/quartet'
    assert last_response.redirect?
  end

  def test_redirects_to_larger_ensembles_search
    get '/larger_ensembles'
    assert last_response.redirect?
  end

end
