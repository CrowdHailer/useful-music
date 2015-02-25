class CustomersController < UsefulMusic::App
  include Scorched::Rest
  get('/:id/change_password') { |id| send :edit_password, id }
  put('/:id/change_password') { |id| send :update_password, id }

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/customers'

  def index
    if current_customer.admin?
      @customers = Customers.all request.GET
      render :index
    else
      flash['error'] = 'Access denied'
      redirect '/'
    end
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
      # TODO untested failure cases, usecase or leave in entity layer
    rescue Veto::InvalidEntity => err
      @form = form
      @validator = validator
      render :new
    rescue Sequel::UniqueConstraintViolation => err
      @form = form
      validator.errors.add(:email, 'is already taken')
      @validator = validator
      render :new
    end
  end

  def show(id)
    @customer = check_access!(id)
    render :show
  end

  def edit(id)
    @customer = check_access!(id)
    @validator = Customer::Create::Validator.new
    render :edit
  end

  def update(id)
    begin
      customer = check_access!(id)
      form = Customer::Update::Form.new request.POST['customer']
      validator = Customer::Update::Validator.new
      validator.validate! form
      form.each do |attr, value|
        customer.public_send "#{attr}=", value
      end
      customer.record.save
      flash['success'] = "Update successful"
      redirect "/customers/#{customer.id}"
      # TODO untested failure cases, usecase or leave in entity layer
    rescue Veto::InvalidEntity => err
      @customer = customer
      @form = form
      @validator = validator
      render :edit
    rescue Sequel::UniqueConstraintViolation => err
      @customer = customer
      @form = form
      validator.errors.add(:email, 'is already taken')
      @validator = validator
      render :edit
    end
  end

  def update_password(id)
    begin
      customer = check_access!(id)
      form = Customer::UpdatePassword::Form.new request.POST['customer']
      validator = Customer::UpdatePassword::Validator.new customer.password
      validator.validate! form
      customer.password = form.password
      customer.record.save
      flash['success'] = "Password Changed"
      redirect "/customers/#{customer.id}"
    rescue Veto::InvalidEntity => err
      @customer = customer
      @form = form
      @validator = validator
      render :edit_password
    end
  end

  def edit_password(id)
    @customer = check_access!(id)
    @validator = Customer::Create::Validator.new
    render :edit_password
  end

  def destroy(id)
    customer = check_access!(id)
    customer.record.destroy
    redirect "/customers/"
  end

  def check_access!(id)
    customer = Customers.find(id)
    if customer && (current_customer.admin? || current_customer.id == customer.id)
      customer
    else
      flash['error'] = 'Access denied'
      redirect '/'
    end
  end
end
