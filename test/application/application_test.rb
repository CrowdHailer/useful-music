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

    def test_404_when_page_not_found
      @app = UsefulMusic::App
      get '/random'
      assert_equal 404, last_response.status
    end
  end
end
