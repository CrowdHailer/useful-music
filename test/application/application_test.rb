require_relative '../test_config'

module UsefulMusic
  class AppTest < MyRecordTest
    include ControllerTesting

    def app
      UsefulMusic::App
    end

    def test_csrf_protection
      skip
      app.stub :config, app.config.merge(:protect_from_csrf => true) do

        assert_raises Rack::Csrf::InvalidCsrfToken do
          post '/customers'
        end

      end
    end

    def test_404_when_page_not_found
      get '/random'
      assert_equal 404, last_response.status
    end

    def test_500_when_error
      skip
      app.stub :config, app.config.merge(:show_exceptions => true) do
        get '/test-error'
        assert_equal 500, last_response.status
      end
    end
  end
end
