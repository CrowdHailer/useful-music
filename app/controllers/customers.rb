class CustomersController < UsefulMusic::App
  include Scorched::Rest
  get('/:id/change_password') { |id| send :edit_password, id }
  put('/:id/change_password') { |id| send :update_password, id }
  get('/:id/orders') { |id| send :order_history, id }
  get('/:id/purchases') { |id| send :purchase_history, id }

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/customers'

  def index
    redirect '/admin/customers', 301
  end

  def new
    @form = Customer::Create::Form.new
    @validator = Customer::Create::Validator.new
    render :new
  end

  def create
    begin
      guest = current_customer
      form = Customer::Create::Form.new request.POST['customer']
      validator = Customer::Create::Validator.new
      validator.validate! form
      customer = Customers.create form
      log_in customer
      if guest.shopping_basket && !guest.shopping_basket.empty?
        # test transfer of basket
        customer.shopping_basket = guest.shopping_basket
        Customers.save customer
      end
      customer_mailer.account_created
      flash['success'] = 'Welcome to Useful Music'
      redirect success_path || "/customers/#{customer.id}"
      # untested failure cases, usecase or leave in entity layer
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
    redirect "/customers/#{@customer.id}/orders"
    # render :show
  end

  def order_history(id)
    @customer = check_access!(id)
    render :order_history
  end

  # def purchase_history(id)
  #   @customer = check_access!(id)
  #   render :purchase_history
  # end

  def edit(id)
    @customer = check_access!(id)
    @form = Customer::Create::Form.new
    @validator = Customer::Create::Validator.new
    render :edit
  end

  def update(id)
    begin
      customer = check_access!(id)
      form = Customer::Update::Form.new request.POST['customer']
      validator = Customer::Update::Validator.new
      validator.validate! form
      customer.set form
      Customers.save customer
      flash['success'] = "Update successful"
      redirect "/customers/#{customer.id}"
      # untested failure cases, usecase or leave in entity layer
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
      Customers.save customer
      flash['success'] = "Password changed"
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
    Customers.remove customer
    redirect "/customers/"
  end

  def check_access!(id)
    customer = Customers[id]
    if customer && (current_customer.admin? || current_customer.id == customer.id)
      customer
    else
      flash['error'] = 'Access denied'
      redirect '/sessions/new'
    end
  end

  def success_path
    path = request.GET.fetch('success_path') { '' }
    path.empty? ? nil : path
  end
end
