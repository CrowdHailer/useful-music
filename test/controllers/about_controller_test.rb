require_relative '../test_config'

class AboutControllerTest < MyRecordTest
  include ControllerTesting

  def app
    AboutController
  end

  def test_index_page_is_available
    assert_ok get '/'
  end

  def test_composers_page_is_available
    assert_ok get '/composers'
  end

  def test_search_and_purchase_page_is_available
    assert_ok get '/search_and_purchase'
  end

  def test_licencing_and_copyright_page_is_available
    assert_ok get '/licencing_and_copyright'
  end

  def test_refunds_page_is_available
    assert_ok get '/refunds'
  end

  def test_privacy_page_is_available
    assert_ok get '/privacy'
  end

  def test_terms_and_conditions_page_is_available
    assert_ok get '/terms_and_conditions'
  end

  def test_contact_page_is_available
    assert_ok get '/contact'
  end

  def test_sitemap_is_available
    assert_ok get '/sitemap'
  end

end
