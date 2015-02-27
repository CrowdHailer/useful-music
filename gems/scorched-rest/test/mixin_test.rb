require_relative './test_config'
require 'rack/test'
require 'scorched'

class MixinTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    @app
  end

  def teardown
    @app = nil
  end

  def test_index_action_called
    mock = MiniTest::Mock.new
    mock.expect :call, 'hello'
    @app = Class.new(Scorched::Controller) do
      include Scorched::Rest
      define_method :index, ->(){mock.call}
    end
    get '/'
    mock.verify
    assert 'hello', last_response.body
  end

  def test_new_action_called
    mock = MiniTest::Mock.new
    mock.expect :call, 'hello'
    @app = Class.new(Scorched::Controller) do
      include Scorched::Rest
      define_method :new, ->(){mock.call}
    end
    get '/new'
    mock.verify
    assert 'hello', last_response.body
  end

  def test_create_action_called
    mock = MiniTest::Mock.new
    mock.expect :call, 'hello'
    @app = Class.new(Scorched::Controller) do
      include Scorched::Rest
      define_method :create, ->(){mock.call}
    end
    post '/'
    mock.verify
    assert 'hello', last_response.body
  end

  def test_show_action_called
    mock = MiniTest::Mock.new
    mock.expect :call, 'hello', ['4']
    @app = Class.new(Scorched::Controller) do
      include Scorched::Rest
      define_method :show, ->(capture){ mock.call(capture)}
    end
    get '/4'
    mock.verify
    assert 'hello', last_response.body
  end

  def test_edit_action_called
    mock = MiniTest::Mock.new
    mock.expect :call, 'hello', ['4']
    @app = Class.new(Scorched::Controller) do
      include Scorched::Rest
      define_method :edit, ->(capture){ mock.call(capture)}
    end
    get '/4/edit'
    mock.verify
    assert 'hello', last_response.body
  end

  def test_update_action_called
    mock = MiniTest::Mock.new
    mock.expect :call, 'hello', ['4']
    @app = Class.new(Scorched::Controller) do
      include Scorched::Rest
      define_method :update, ->(capture){ mock.call(capture)}
    end
    put '/4'
    mock.verify
    assert 'hello', last_response.body
  end

  def test_update_action_called_with_patch
    mock = MiniTest::Mock.new
    mock.expect :call, 'hello', ['4']
    @app = Class.new(Scorched::Controller) do
      include Scorched::Rest
      define_method :update, ->(capture){ mock.call(capture)}
    end
    patch '/4'
    mock.verify
    assert 'hello', last_response.body
  end

  def test_destroy_action_called
    mock = MiniTest::Mock.new
    mock.expect :call, 'hello', ['4']
    @app = Class.new(Scorched::Controller) do
      include Scorched::Rest
      define_method :destroy, ->(capture){ mock.call(capture)}
    end
    delete '/4'
    mock.verify
    assert 'hello', last_response.body
  end
end
