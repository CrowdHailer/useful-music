class OrdersController < UsefulMusic::App
  include Scorched::Rest
  # get('/:id/download_licence') { |id| send :download, id }

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/orders'

  def index
    response['Allow'] = 'POST'
    halt 405
  end

  def create
    send_to_login if current_customer.guest?
    send_back('Checkout unavailable') unless ENV.fetch('SUSPEND_PAYMENTS', '').empty?
    send_back('Your shopping basket is empty') if shopping_basket.empty?
    remove_discount('Your discount has expired') if shopping_basket.discount.expired?
    remove_discount('Your discount is pending') if shopping_basket.discount.pending?
    # ap ShoppingBaskets.new(:checked_out => true, :discount => shopping_basket.discount).dataset.sql
    if !shopping_basket.discount.nil? && shopping_basket.discount.allocation <= ShoppingBaskets.count(:checked_out => true, :discount => shopping_basket.discount)
      remove_discount('This discount code has been used')
    end
    count = current_customer.orders.select{ |o|
      o.succeded? && o.discount == shopping_basket.discount
    }.count
    remove_discount('You have used this discount code') if !shopping_basket.discount.nil? && count >= shopping_basket.discount.customer_allocation
    # ap ShoppingBaskets.all
    # ap Orders.new(:discount => shopping_basket.discount).dataset.sql
    # remove_discount if discount.all_spent
    # remove_discount if discount.spent_by(current_customer)
    order = Orders.build :customer => current_customer,
      :shopping_basket => shopping_basket
    order.calculate_payment
    Orders.save order
    if shopping_basket.free?
      order.state = 'succeded'
      order.record.save
      customer_mailer.order_successful
      current_customer.record.update :shopping_basket_record => nil
      session.delete 'guest.shopping_basket'

      flash[:success] = 'Order placed successfuly'
      redirect "customers/#{current_customer.id}"
    else
      redirect order.setup(url).redirect_uri
    end
  end

  def send_to_login
    flash['error'] = 'Please Sign in or Create account to checkout purchases'
    redirect "/sessions/new?requested_path=#{request.referer}"
  end

  def send_back(message)
    flash['error'] = message
    redirect "/shopping_baskets/#{shopping_basket.id}"
  end

  def remove_discount(message)
    b = shopping_basket
    b.discount = nil
    ShoppingBaskets.save b
    flash['error'] = message
    redirect "/shopping_baskets/#{shopping_basket.id}"
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
    order = Orders.fetch(id)
    order.state = 'failed'
    order.completed_at = DateTime.now
    Orders.save order
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
