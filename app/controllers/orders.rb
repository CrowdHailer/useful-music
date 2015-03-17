class OrdersController < UsefulMusic::App
  include Scorched::Rest
  # get('/:id/download_licence') { |id| send :download, id }

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/orders'

  def create
    send_to_login if current_customer.guest?
    send_back if shopping_basket.empty?
    discount_code = request.POST['discount']
    if discount_code && !discount_code.empty?
      discount = Discounts.available(discount_code)
      invalid_discount if discount.nil?
      used_discount if Orders.first(
        :succeded => true,
        :customer => current_customer,
        :discount => discount
      )
    else
      discount = nil
    end
    order = Orders.build :customer => current_customer,
      :shopping_basket => shopping_basket,
      :discount => discount
    order.calculate_payment
    Orders.save order
    redirect order.setup(url).redirect_uri
  end

  def send_to_login
    flash['error'] = 'Please Sign in or Create account to checkout purchases'
    redirect '/sessions/new'
  end

  def send_back
    flash['error'] = 'Your shopping basket is empty'
    redirect request.referer
  end

  def invalid_discount
    flash['error'] = 'This discount code is invalid'
    redirect request.referer
  end

  def used_discount
    flash['error'] = 'This discount code has been used'
    redirect request.referer
  end

  def show(id)
    # TODO check access
    @order = Order.new(Order::Record[id])
    html = render :show, :layout => nil
    kit = PDFKit.new(html)
    kit.stylesheets << File.expand_path('./public/stylesheets/licence.css', APP_ROOT)
    pdf = kit.to_pdf#
    file = Tempfile.new('foo')
    # ap file.path
    file.write(pdf)
    @order.record.update(:licence => {:type => 'application/pdf', :tempfile => file})
    @order.record.save
    html = render :show, :layout => nil
    redirect @order.record.licence.url
    # render :show
  end

  get '/:id/cancel' do |id|
    flash['success'] = 'Order cancelled'
    redirect '/'
  end

  get '/:id/success' do |id|
    order = Orders.fetch(id)
    token = request.GET['token']
    payer_ID = request.GET['PayerID']
    order.fetch_details token
    order.checkout token, payer_ID
    customer_mailer.order_successful
    current_customer.record.update :shopping_basket_record => nil
    session.delete 'guest.shopping_basket'

    flash[:success] = 'Order placed successfuly'
    redirect "customers/#{current_customer.id}"
  end

end
