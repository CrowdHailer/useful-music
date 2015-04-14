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

    def csrf_tag
      Rack::Csrf.csrf_tag(env)
    end

    def csrf_token
      Rack::Csrf.csrf_token(env)
    end

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

    def shopping_basket
      customer = current_customer
      return customer.shopping_basket if customer.shopping_basket
      if customer.guest?
        customer.shopping_basket ||= ShoppingBaskets.create
      else
        customer.record.update :shopping_basket_record => ShoppingBaskets.create.record
      end
      customer.shopping_basket
    end

    def customer_mailer
      CustomerMailer.new(current_customer, :application_url => url)
    end
  end
end

Dir[File.expand_path('app/controllers/*.rb', APP_ROOT)].each { |file| require file}
Dir[File.expand_path('app/mailers/*.rb', APP_ROOT)].each { |file| require file}

class UsefulMusic::App
  TestError = Class.new(StandardError)
  NotFoundError = Class.new(StandardError)
  # belongs in top setting
  config[:protect_from_csrf] = !(RACK_ENV == 'test')

  middleware << proc do |app|
    use Bugsnag::Rack
    use Rack::GoogleAnalytics, :tracker => ENV['GOOGLE_ANALYTICS_CODE'], :ecommerce => true if RACK_ENV == 'production' || RACK_ENV == 'staging'
    use Rack::Session::Cookie, secret: ENV.fetch('SESSION_SECRET_KEY')
    use Rack::Protection
    use Rack::Csrf, :raise => true if app.config[:protect_from_csrf]
    use Rack::MethodOverride
  end

  get '/test-error' do
    raise TestError, 'This is a drill'
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
    response.body = render File.expand_path('app/views/errors/404', APP_ROOT).to_sym, :layout => File.expand_path('app/views/error', APP_ROOT).to_sym
  end

  error do |err|
    env["rack.exception"] = err
    false
  end

  error do |err|
    if RACK_ENV == 'production'
      @err = err
      Bugsnag.notify(err, :severity => "error")
      response.status = 500
      response.body = render File.expand_path('app/views/errors/500', APP_ROOT).to_sym, :layout => File.expand_path('app/views/error', APP_ROOT).to_sym
    end
  end
end
