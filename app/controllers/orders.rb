class OrdersController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/orders'

  def create
    shopping_basket_record = ShoppingBasket::Record[request.POST['order']['shopping_basket_id']]
    Order::Record.last.destroy if Order::Record.last
    order = Order.create do |order|
      order.record.shopping_basket_record = shopping_basket_record
      order.record.state = 'initialized'
      order.record.customer_record = current_customer.record
    end
    paypal_options = {
      no_shipping: true, # if you want to disable shipping information
      allow_note: false, # if you want to disable notes
      pay_on_paypal: true # if you don't plan on showing your own confirmation step
    }
    express_request = Paypal::Express::Request.new(
      :username   => ENV.fetch('PAYPAL_USERNAME'),
      :password   => ENV.fetch('PAYPAL_PASSWORD'),
      :signature  => ENV.fetch('PAYPAL_SIGNATURE')
    )

    payment_request = Paypal::Payment::Request.new(
      :currency_code => :GBP,   # if nil, PayPal use USD as default
      # :description   => 'Lovely',    # item description
      # :quantity      => 1,      # item quantity
      # :amount        => order.record.shopping_basket_record.purchase_records.map{|r| Purchase.new r}.reduce(0){|t, i| i.price},   # item value
      :amount => 2.64,
      :items => [{
        :name => 'blah',
        :description => 'some',
        :amount => 1.32,
        :quantity => 2,
        :category => :Digital
      }],
      :custom_fields => {
        CARTBORDERCOLOR: "01344C",
        LOGOIMG: "https://example.com/logo.png"
      }
    )
    express_response = express_request.setup(
      payment_request,
      "http://localhost:9393/orders/#{order.id}/edit",
      'http://localhost:9393/cancel',
      paypal_options  # Optional
    )
    redirect express_response.redirect_uri
  end

  def edit(id)
    order_record = Order::Record[id]
    express_request = Paypal::Express::Request.new(
      :username   => ENV.fetch('PAYPAL_USERNAME'),
      :password   => ENV.fetch('PAYPAL_PASSWORD'),
      :signature  => ENV.fetch('PAYPAL_SIGNATURE')
    )
    token = request.GET['token']
    # ap express_response = express_request.details(token)
    # ap express_response.payer.identifier
    # ap express_response.payer.first_name
    # ap express_response.payer.last_name
    # ap express_response.payer.email
    # ap express_response.payer.company
    # ap express_response.amount
    # ap express_response.ship_to
    # ap express_response.payment_responses
    payer_id = request.GET['PayerID']
    payment_request = Paypal::Payment::Request.new(
      :currency_code => :GBP,   # if nil, PayPal use USD as default
      # :description   => 'Lovely',    # item description
      # :quantity      => 1,      # item quantity
      # :amount        => order.record.shopping_basket_record.purchase_records.map{|r| Purchase.new r}.reduce(0){|t, i| i.price},   # item value
      :amount => 2.64,
      :items => [{
        :name => 'blah',
        :description => 'some',
        :amount => 1.32,
        :quantity => 2,
        :category => :Digital
      }],
      :custom_fields => {
        CARTBORDERCOLOR: "C000C0",
        LOGOIMG: "https://example.com/logo.png"
      }
    )
    ap payer_id
    ap token
    checkout_response = express_request.checkout!(
      token,
      payer_id,
      payment_request
    )
    ap checkout_response
    ap order_record.shopping_basket_record.purchase_records.map(&:item_record).map{|r| "UD#{r.piece_id} #{r.name}"}
  end
end
