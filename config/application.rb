require File.expand_path("../boot.rb", __FILE__)

module UsefulMusic
  class App < Scorched::Controller
    render_defaults[:dir] = File.expand_path('app/views', APP_ROOT).freeze
    render_defaults[:layout] = File.expand_path('app/views/application', APP_ROOT).to_sym
    config[:static_dir] = 'public'

    def log_in(customer)
      session[:user_id] = customer.id
    end

    def log_out
      session.delete(:user_id)
      @current_user = nil
    end

    def show_admin
      current_customer.admin? && request.GET['incognito'] != 'on'
    end

    def incognito_uri
      current_uri = request.env['REQUEST_URI']
      current_uri.include?('?') ? current_uri + '&incognito=on' : current_uri + '?incognito=on'
    end

    def csrf_tag
      Rack::Csrf.csrf_tag(env)
    end

    # Return the anti-CSRF token
    def csrf_token
      Rack::Csrf.csrf_token(env)
    end

    # Return the field name which will be looked for in the requests.
    def csrf_field
      Rack::Csrf.csrf_field
    end

    def current_customer
      Customers.fetch(session[:user_id]) { Guest.new(session) }
    end

    def admin_logged_in?
      current_customer.admin?
    end

    def deny_access
      flash['error'] = 'Access denied'
      redirect '/'
    end

    def live_shopping_basket_id
      if session['useful_music.basket_id'] && ShoppingBasket::Record[session['useful_music.basket_id']]
        session['useful_music.basket_id']
      else
        session['useful_music.basket_id'] = ShoppingBasket::Record.create.id
      end
    end

    def shopping_basket
      # # TODO not good
      # # ShoppingBasket.new(ShoppingBasket::Record[live_shopping_basket_id])
      # ShoppingBasket.new(ShoppingBasket::Record.new)
      ShoppingBaskets.fetch(live_shopping_basket_id)
    end

    def customer_mailer
      CustomerMailer.new(current_customer, :application_url => url)
    end

    # def guest_session
    #   session.each_with_object({}) do |(key, value), obj|
    #     if key.match(/guest.(.+)/)
    #       obj[$1] = value
    #     end
    #   end
    # end
  end
end

# Load all controllers
Dir[File.expand_path('app/controllers/*.rb', APP_ROOT)].each { |file| require file}
Dir[File.expand_path('app/mailers/*.rb', APP_ROOT)].each { |file| require file}

class UsefulMusic::App
  NotFoundError = Class.new(StandardError)
  # belongs in top setting
  config[:protect_from_csrf] = !(RACK_ENV == 'test')

  middleware << proc do |app|
    use Bugsnag::Rack
    use Rack::Session::Cookie, secret: ENV.fetch('SESSION_SECRET_KEY')
    use Rack::Csrf, :raise => true if app.config[:protect_from_csrf]
    use Rack::MethodOverride
  end

  controller '/customers', CustomersController
  controller '/sessions', SessionsController
  controller '/password_resets', PasswordResetsController
  controller '/pieces', PiecesController
  controller '/purchases', PurchasesController
  controller '/shopping_baskets', ShoppingBasketsController
  controller '/orders', OrdersController
  controller '/about', AboutController
  controller '/admin', UsefulMusic::AdminController
  controller '/', HomeController

  after :status => 404 do
    error = NotFoundError.new "Attempted Path: #{request.path}"
    Bugsnag.notify(error, :severity => "info")
  end

  error do
    env["rack.exception"] = $!
    false
  end
end
