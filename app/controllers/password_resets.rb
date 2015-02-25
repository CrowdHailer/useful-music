class PasswordResetsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/password_resets'

  def new
    render :new
  end

  def create
    form = OpenStruct.new(:email => request.POST['customer']['email'])
    customer = Customer.new(Customer::Record.find(:email => form.email)) if Customer::Record.find(:email => form.email)
    ap customer
  end
end
