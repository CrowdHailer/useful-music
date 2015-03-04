class DiscountsController < UsefulMusic::App
  include Scorched::Rest

  render_defaults[:dir] += '/discounts'

  before do
    check_access
  end

  def index
    @discounts = Discounts.new
    render :index
  end

  def new
    render :new
  end

  def create
    form = Discount::Create::Form.new request.POST['discount']
    Discount::Record.create form.to_hash
    flash['success'] = 'Discount Created'
    redirect '/discounts'
  end

  def edit(id)
    @discount = Discounts[id]
    render :edit
  end

  def update(id)
    form = Discount::Create::Form.new request.POST['discount']
    discount = Discounts[id]
    discount.set form.to_hash
    Discounts.save discount
    flash['success'] = 'Discount Updated'
    redirect '/discounts'
  end

  def destroy(id)
    discount = Discounts[id]
    Discounts.destroy(discount)
    flash['success'] = 'Discount Deleted'
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
