class BasketController < UsefulMusic::App
  # NOTE: need to create new string to assign in config dir
  # render_defaults[:dir] += '/home'

  # get '/' do
  #   render :index
  # end

  get '/:id' do |id|
    id
    basket = Basket::Record[id]
    ap basket.purchase_records
    ap basket.purchase_records.first.item_record

    basket.purchase_records.map{|r| Purchase.new r}.reduce(0){|t, i| i.price}
  end

  post '/add_purchases' do
    if session['useful_music.basket_id']
      basket = Basket::Record[session['useful_music.basket_id']]
    else
      basket = Basket::Record.create
      session['useful_music.basket_id'] = basket.id
    end
    add_form.each do |purchase_data|
      purchase_record = Purchase::Record.new purchase_data
      basket.add_purchase_record purchase_record
    end
    ap add_form.to_s
    redirect "/basket/#{basket.id}"
  end

  def add_form
     request.POST['purchases']
  end
end
