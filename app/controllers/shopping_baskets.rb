class ShoppingBasketsController < UsefulMusic::App
  include Scorched::Rest
  render_defaults[:dir] += '/shopping_baskets'

  def show(id)
    @basket = ShoppingBaskets.fetch(id, &method(:shopping_basket_not_found))
    render :show
  end

  def update(id)
    ShoppingBaskets.fetch(id, &method(:shopping_basket_not_found))
  end

  def destroy(id)
    basket = ShoppingBaskets.fetch(id, &method(:shopping_basket_not_found))
    customer = current_customer
    unless customer.guest?
      customer.record.update :shopping_basket_record => nil
    end
    ShoppingBaskets.remove basket
    flash['success'] = 'Shopping basket cleared'
    redirect '/'
  end

  def shopping_basket_not_found(id)
    flash['error'] = 'Shopping Basket not found'
    redirect request.referer
  end

end
