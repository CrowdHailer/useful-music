class PasswordResetsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/password_resets'

  def new
    @customer_email_unknown = false
    render :new
  end

  def create
    form = OpenStruct.new(:email => request.POST['customer']['email'])
    customer = Customers.find_by_email(form.email)
    if customer
      customer.create_password_reset
      customer.record.save
      # Set customer on mailer after creation?
      CustomerMailer.new(customer, :application_url => url).password_reset_created
      flash['success'] = 'A password reset as been sent to your email'
      redirect '/sessions/new'
    else
      @customer_email_unknown = true
      render :new
    end
  end

  def edit(id)
    @validator = PasswordReset::Update::Validator.new
    email = request.GET['email']
    @id = id
    @customer = Customers.find_by_email(email)
    render :edit
  end

  def update(id)
    email = request.POST['email']
    customer = Customers.find_by_email(email)
    if customer && customer.password_reset_token == id
    else
    end
    ''
  end
end
