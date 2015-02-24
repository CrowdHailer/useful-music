class CustomersController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/customers'

  def index
    @customers = Customers.all request.GET
    render :index
  end

  def new
    @form = Customer::Create::Form.new
    @validator = Customer::Create::Validator.new
    render :new
  end

  def create
    begin
      form = Customer::Create::Form.new request.POST['customer']
      validator = Customer::Create::Validator.new
      validator.validate! form
      customer = Customer.create form
      log_in customer
      customer_mailer.account_created
      flash['success'] = 'Welcome to Useful Music'
      redirect "/customers/#{customer.id}"
    rescue Veto::InvalidEntity => err
      @form = form
      @validator = validator
      render :new
    end
  end

  def show(id)
    customer = Customers.find(id)
    if customer && current_customer.id == customer.id
      @customer = customer
      render :show
    else
      flash['error'] = 'Access denied'
      redirect '/customers'
    end
  end

  def edit(id)
    @customer = Customers.find(id)
    render :edit
  end

  def update(id)
    customer = Customers.find(id)
    form = Customer::Update::Form.new request.POST['customer']
    validator = Customer::Update::Validator.new
    validator.validate! form
    form.each do |attr, value|
      customer.public_send "#{attr}=", value
    end
    customer.record.save
    flash[:success] = "#{customer.name} Your Useful Music account is created"
    redirect "/customers/#{customer.id}"
  end

  def destroy(id)
    customer = Customers.find(id)
    customer.record.destroy
    redirect "/customers/"
  end
end
