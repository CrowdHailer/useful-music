class OrdersController < UsefulMusic::App
  include Scorched::Rest
  # get('/:id/download_license') { |id| send :download, id }

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/orders'

  def create
    form = Order::Create::Form.new request.POST['order']
    form.customer = current_customer
    order = Order.create(form.to_hash) do |order|
      order.calculate_prices
      order.transaction
    end
    redirect order.setup(url).redirect_uri
  end

  def show(id)
    # TODO check access
    @order = Order.new(Order::Record[id])
    html = render :show, :layout => nil
    kit = PDFKit.new(html)
    ap File.expand_path('./public/stylesheets/license.css', APP_ROOT)
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
    order = Order.new(Order::Record[id])
    order.fetch_details request.GET['token']
    ap order.record.values
    order.checkout request.GET['token'], request.GET['PayerID']
    ap order.record.values
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
