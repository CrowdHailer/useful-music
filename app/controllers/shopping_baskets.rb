class ShoppingBasketsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/shopping_baskets'

  # TODO test

  def show(id)
    @basket = ShoppingBasket.new ShoppingBasket::Record[id]
    render :show
  end

  def destroy(id)
    record = ShoppingBasket::Record[id]
    record.destroy
    flash['success'] = 'Shopping basket cleared'
    redirect '/'
  end

end
