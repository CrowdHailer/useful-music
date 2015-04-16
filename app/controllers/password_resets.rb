class PasswordResetsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/password_resets'

  def index
    response['Allow'] = 'POST'
    halt 405
  end

  def new
    @customer_email_unknown = false
    render :new
  end

  def create
    form = OpenStruct.new(:email => request.POST['customer']['email'])
    customer = Customers.find_by_email(form.email)
    if customer
      customer.create_password_reset
      customer.save
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
    @validator = PasswordReset::Update::Validator.new
    @form = PasswordReset::Update::Form.new request.POST['customer']
    begin
      @validator.validate! @form
      # TODO add time validation
      if customer && customer.password_reset_token == id
        customer.password = @form.password
        customer.save
        flash['success'] = 'Password changed'
        redirect '/sessions/new'
      else
        flash['error'] = 'Reset token invalid or expired'
        redirect '/password_resets/new'
      end
    rescue Veto::InvalidEntity => err
      @id = id
      @customer = customer
      render :edit
    end
  end
end
