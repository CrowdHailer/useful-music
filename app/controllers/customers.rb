class CustomersController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/customers'

  def new
    render :new
  end

  def create
    # ap request.POST['customer']
    Customer.create :email => request.POST['customer']['email']
  end
end
