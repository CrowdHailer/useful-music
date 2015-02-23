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
  end
end
