class SessionsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/sessions'

  def new
    if current_customer.id
      redirect "/customers/#{current_customer.id}"
    else
      render :new
    end
  end

  def create
    form = Session::Create::Form.new request.POST['session']
    validator = Session::Create::Validator.new
    customer = validator.valid?(form) && Customers.authenticate(form.email, form.password)
    if customer
      log_in customer
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
