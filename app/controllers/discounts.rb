class DiscountsController < UsefulMusic::App
  include Scorched::Rest

  render_defaults[:dir] += '/discounts'

  before do
    check_access
  end

  def index
    render :index
  end

  def new
    render :new
  end

  def create
    form = request.POST['discount']
    ap form
    Discount::Record.create form
    flash['success'] = 'Discount Created'
    redirect '/discounts'
  end

  def check_access
    if current_customer.admin?
      true
    else
      flash['error'] = 'Access denied'
      redirect '/'
    end
  end
end
