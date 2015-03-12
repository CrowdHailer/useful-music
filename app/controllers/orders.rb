class OrdersController < UsefulMusic::App
  include Scorched::Rest
  # get('/:id/download_license') { |id| send :download, id }

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/orders'

  def create
    send_to_login if current_customer.guest?
    send_back if shopping_basket.empty?
    order = Orders.build :customer => current_customer, :shopping_basket => shopping_basket
    order.mark_pending
    order.calculate_prices
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

  def show(id)
    # TODO check access
    @order = Order.new(Order::Record[id])
    html = render :show, :layout => nil
    kit = PDFKit.new(html)
    kit.stylesheets << File.expand_path('./public/stylesheets/license.css', APP_ROOT)
    pdf = kit.to_pdf#
    file = Tempfile.new('foo')
    # ap file.path
    file.write(pdf)
    @order.record.update(:license => {:type => 'application/pdf', :tempfile => file})
    @order.record.save
    html = render :show, :layout => nil
    redirect @order.record.license.url
    # render :show
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
