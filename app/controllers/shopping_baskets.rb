class ShoppingBasketsController < UsefulMusic::App
  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/shopping_baskets'

  # get '/' do
  #   render :index
  # end

  get '/:id' do |id|
    @basket = ShoppingBasket::Record[id]
    render :show
  end

end
