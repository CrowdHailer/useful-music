class PurchasesController < UsefulMusic::App
  include Scorched::Rest

  render_defaults[:dir] += '/purchases'

  def index
    @purchases = Purchase::Record.all.map{ |r| Purchase.new r }
    render :index
  end

  def create
    batch = Purchase::Create::Form.many request.POST['purchases']
    # TODO batch valid
    # TODO consider separate error object, do we want to assume same shopping cart
    batch.each do |form|
      begin
        Purchases.create form
      rescue Sequel::UniqueConstraintViolation => e
        purchase_record = Purchase::Record
          .where(:shopping_basket_id => form.shopping_basket.id)
          .where(:item_id => form.item.id)
          .first
        purchase_record.quantity += form.quantity
        purchase_record.save
      rescue Sequel::NotNullConstraintViolation => e
        flash['error'] = 'Add items to shopping basket failed'
        redirect (request.referer || '/')
      end
    end
    redirect '/my-shopping-basket'

    # batch = Purchase::Create::Form.many request.POST['purchases']
    # batch.valid?
    # batch.each do |form|
    #   Purchase.create_or_update form
    # end
  end

  def update(id)
    purchase = Purchases.fetch(id) do
      flash['error'] = 'Could not update basket'
      redirect (request.referer || '/')
    end
    quantity = request.POST['purchase']['quantity'].to_i
    if quantity > 0
      purchase.quantity = quantity
      Purchases.save purchase
      flash['success'] = 'Shopping basket updated'
      redirect (request.referer || '/')
    else
      flash['error'] = 'Could not update basket'
      redirect (request.referer || '/')
    end
  end

  def destroy(id)
    purchase = Purchases.fetch(id) do
      flash['error'] = 'Could not update basket'
      redirect (request.referer || '/')
    end
    Purchases.remove purchase
    flash[:success] = 'Item removed from basket'
    redirect request.referer
  end
end
