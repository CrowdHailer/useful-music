class OrdersController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/orders'

  def create
    form = Order::Create::Form.new request.POST['order']
    form.customer = current_customer
    redirect Order.create(form).setup.redirect_uri
  end

  get '/:id/success' do |id|
    order = Order.new(Order::Record[id])
    order.fetch_details request.GET['token']
    order.checkout request.GET['token'], request.GET['PayerID']
    session['useful_music.basket_id'] = nil
    # template = Tilt::ERBTemplate.new('template.erb')
    mail = Mail.new
    mail.from 'info@usefulmusic.com'
    mail.to order.customer.email
    mail.subject 'Here is a message'
    mail.body "Your purchases are available in your account for the next 4 days"
    mail.deliver

    flash[:success] = 'Order placed successfuly'
    redirect "customers/#{current_customer.id}"
  end

end
