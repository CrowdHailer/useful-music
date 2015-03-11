class SessionsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/sessions'

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
    guest = current_customer
    ap session
    # ap guest.shopping_basket && guest.shopping_basket.empty?

    customer = validator.valid?(form) && Customers.authenticate(form.email, form.password)
    if customer
      log_in customer
      customer.shopping_basket = guest.shopping_basket
      Customers.save customer
      flash['success'] = "Welcome back #{customer.name}"
      redirect "/customers/#{customer.id}"
    else
      flash['error'] = 'Invalid login details'
      redirect '/sessions/new'
    end
  end

  delete '/' do
    log_out
    redirect '/'
  end

end
