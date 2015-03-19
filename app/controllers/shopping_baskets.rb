class ShoppingBasketsController < UsefulMusic::App
  include Scorched::Rest
  render_defaults[:dir] += '/shopping_baskets'

  def show(id)
    @basket = ShoppingBaskets.fetch(id) { redirect '/' }
    render :show
  end

  def destroy(id)
    customer = current_customer
    unless customer.guest?
      customer.record.update :shopping_basket_record => nil
    end
    record = ShoppingBasket::Record[id]
    record.destroy
    flash['success'] = 'Shopping basket cleared'
    redirect '/'
  end

end
