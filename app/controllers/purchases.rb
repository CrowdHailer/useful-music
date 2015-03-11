class PurchasesController < UsefulMusic::App
  include Scorched::Rest

  render_defaults[:dir] += '/purchases'

  def index
    @purchases = Purchase::Record.all.map{ |r| Purchase.new r }
    render :index
  end

  def create
    batch = Purchase::Create::Batch.new request.POST['purchases']
    if batch.valid?
      batch.each do |form|
        begin
          Purchases.create form
        rescue Sequel::UniqueConstraintViolation => e
          purchase = Purchases.first(form.to_hash)
          purchase.quantity += form.quantity
          Purchases.save purchase
        end
      end
      redirect (request.referer || '/my-shopping-basket')

      # batch.each do |form|
      #   Purchase.create_or_update form
      # end
    else
      flash['error'] = 'Add items to shopping basket failed'
      redirect (request.referer || '/')
    end
  end

  def update(id)
    purchase = Purchases.fetch(id, &method(:basket_update_failed))
    quantity = request.POST['purchase']['quantity'].to_i
    if quantity > 0
      purchase.quantity = quantity
      Purchases.save purchase
      flash['success'] = 'Shopping basket updated'
      redirect (request.referer || '/')
    else
      basket_update_failed(id)
    end
  end

  def destroy(id)
    purchase = Purchases.fetch(id, &method(:basket_update_failed))
    Purchases.remove purchase
    flash[:success] = 'Item removed from basket'
    redirect request.referer
  end

  def basket_update_failed(id)
    flash['error'] = 'Could not update basket'
    redirect (request.referer || '/')
  end
end
