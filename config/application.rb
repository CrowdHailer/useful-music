require File.expand_path("../boot.rb", __FILE__)

module UsefulMusic
  class App < Scorched::Controller
    render_defaults[:dir] = File.expand_path('app/views', APP_ROOT).freeze
    render_defaults[:layout] = File.expand_path('app/views/application', APP_ROOT).to_sym
    config[:static_dir] = 'public'
    def warden_handler
      env['warden']
    end

    def current_customer
      warden_handler.user || Guest.new
    end

    def live_shopping_basket_id
      if session['useful_music.basket_id'] && ShoppingBasket::Record[session['useful_music.basket_id']]
        session['useful_music.basket_id']
      else
        session['useful_music.basket_id'] = ShoppingBasket::Record.create.id
      end
    end

    def shopping_basket
      ShoppingBasket.new(ShoppingBasket::Record[live_shopping_basket_id])
    end

    def customer_mailer
      CustomerMailer.new(current_customer, :application_url => url)
    end
  end
end

# Load all controllers
Dir[File.expand_path('app/controllers/*.rb', APP_ROOT)].each { |file| require file}
Dir[File.expand_path('app/mailers/*.rb', APP_ROOT)].each { |file| require file}

class UsefulMusic::App
  middleware << proc do
    # TODO secure session
    use Rack::Session::Cookie, secret: 'blah'
    # TODO secure csrf
    # use Rack::Csrf, :raise => true
    use Rack::MethodOverride
    use Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app = AuthenticationController
      manager.serialize_into_session { |customer| customer.id }
      manager.serialize_from_session { |id| Customers.find(id) }
    end
  end
  controller '/authentication', AuthenticationController
  controller '/customers', CustomersController
  controller '/pieces', PiecesController
  controller '/items', ItemsController
  controller '/purchases', PurchasesController
  controller '/shopping_baskets', ShoppingBasketsController
  controller '/orders', OrdersController
  controller '/about', AboutController
  controller '/', HomeController
end
