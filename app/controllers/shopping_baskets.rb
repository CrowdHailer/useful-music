class ShoppingBasketsController < UsefulMusic::App
  include Scorched::Rest
  render_defaults[:dir] += '/shopping_baskets'

  def index
    response['Allow'] = 'POST'
    halt 405
  end

  def show(id)
    @basket = ShoppingBaskets.fetch(id, &method(:shopping_basket_not_found))
    render :show
  end

  def update(id)
    shopping_basket = ShoppingBaskets.fetch(id, &method(:shopping_basket_not_found))
    code = request.POST.fetch('shopping_basket') { {} }['discount'] || ''
    discount = Discounts.first(:code => code)
    if code.empty?
      flash['success'] = 'Discount Code Removed'
      shopping_basket.discount = nil
      ShoppingBaskets.save shopping_basket
    elsif discount.nil?
      flash['error'] = 'Discount Code Invalid'
    elsif discount.expired? || discount.pending?
      flash['error'] = 'Discount Code Currently Unavailable'
    else
      flash['success'] = 'Discount Code Added'
      shopping_basket.discount = discount
      ShoppingBaskets.save shopping_basket
    end
    redirect "/shopping_baskets/#{shopping_basket.id}"
  end

  def destroy(id)
    basket = ShoppingBaskets.fetch(id, &method(:shopping_basket_not_found))
    customer = current_customer
    unless customer.guest?
      customer.set! :shopping_basket => nil
    end
    ShoppingBaskets.remove basket
    flash['success'] = 'Shopping basket cleared'
    redirect '/'
  end

  def shopping_basket_not_found(id)
    flash['error'] = 'Shopping Basket not found'
    redirect (request.referer || '/').dup
  end

end
