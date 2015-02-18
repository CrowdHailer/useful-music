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

  delete '/*/purchase/*' do |basket_id, purchase_id|
    # "#{basket_id} + #{purchase_id}"
    Purchase::Record[purchase_id].destroy
    redirect "/shopping_baskets/#{basket_id}"
  end

  post '/add_purchases' do
    if session['useful_music.basket_id']
      basket = ShoppingBasket::Record[session['useful_music.basket_id']]
    else
      basket = ShoppingBasket::Record.create
      session['useful_music.basket_id'] = basket.id
    end
    add_form.each do |purchase_data|
      purchase_record = Purchase::Record.new purchase_data
      basket.add_purchase_record purchase_record
    end
    redirect "/shopping_baskets/#{basket.id}"
  end

  def add_form
     request.POST['purchases']
  end
end
