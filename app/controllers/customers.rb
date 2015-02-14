class CustomersController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/customers'

  def index
    @customers = Customer::Record.all.map{ |r| Customer.new r }
    render :index
  end

  def new
    render :new
  end

  def create
    form = Customer::Create::Form.new request.POST['customer']
    validator = Customer::Create::Validator.new
    validator.validate! form
    Customer.create form
    redirect '/customers'
  end
end
