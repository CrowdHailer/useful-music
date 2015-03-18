require_relative '../test_config'

module UsefulMusic
  class AppTest < MyRecordTest
    include ControllerTesting

    attr_reader :app

    def test_csrf_protection
      skip
      assert_raises Rack::Csrf::InvalidCsrfToken do
        post '/customers'
      end
    end

    def test_redirects_when_page_not_found
      @app = UsefulMusic::App
      get '/random'
      # TODO scorced issue
      # assert_equal 'Page not found', flash['error']
      assert last_response.redirect?
    end
  end
end
