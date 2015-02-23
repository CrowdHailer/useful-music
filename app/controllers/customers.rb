class CustomersController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/customers'

  def index
    @customers = Customers.all
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
      warden_handler.set_user(customer) # TODO test
      customer_mailer.account_created
      redirect "/customers/#{customer.id}"
    rescue Veto::InvalidEntity => err
      @form = form
      @validator = validator
      render :new
    end
  end

  def show(id)
    @customer = Customers.find(id)
    render :show
  end

  def edit(id)
    @customer = Customers.find(id)
    render :edit
  end

  def update(id)
    ap request.POST
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
