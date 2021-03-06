class SessionsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/sessions'

  def index
    response['Allow'] = 'POST'
    halt 405
  end

  def new
    if current_customer.guest?
      render :new
    else
      redirect "/customers/#{current_customer.id}"
    end
  end

  def create
    form = Session::Create::Form.new request.POST['session']
    validator = Session::Create::Validator.new

    customer = validator.valid?(form) && Customers.authenticate(form.email, form.password)
    if customer
      guest = current_customer
      log_in customer
      if guest.shopping_basket && !guest.shopping_basket.empty?
        customer.shopping_basket = guest.shopping_basket
        Customers.save customer
      end
      flash['success'] = "Welcome back #{customer.name}"
      redirect redirect_path || "/customers/#{customer.id}"
    else
      flash['error'] = 'Invalid login details'
      redirect '/sessions/new'
    end
  end

  delete '/' do
    log_out
    redirect '/'
  end

  def redirect_path
    path = request.POST.fetch('requested_path') { '' }
    path.empty? ? nil : path
  end

  def requested_path
    path = request.GET.fetch('requested_path') { '' }
    path.empty? ? nil : path
  end

end
