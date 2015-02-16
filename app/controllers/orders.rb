class OrdersController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/orders'

  def create
    ap request.POST
    shopping_basket = ShoppingBasket::Record[request.POST['order']['shopping_basket_id']]
    ap shopping_basket.purchase_records
    ap shopping_basket.purchase_records.map{|r| Purchase.new r}.reduce(0){|t, i| i.price}
    paypal_options = {
      no_shipping: true, # if you want to disable shipping information
      allow_note: false, # if you want to disable notes
      pay_on_paypal: false # if you don't plan on showing your own confirmation step
    }
    express_request = Paypal::Express::Request.new(
      :username   => ENV.fetch('PAYPAL_USERNAME'),
      :password   => ENV.fetch('PAYPAL_PASSWORD'),
      :signature  => ENV.fetch('PAYPAL_SIGNATURE')
    )

    payment_request = Paypal::Payment::Request.new(
      :currency_code => :GBP,   # if nil, PayPal use USD as default
      :description   => 'Lovely',    # item description
      :quantity      => 4,      # item quantity
      :amount        => 8.00,   # item value
      :custom_fields => {
        CARTBORDERCOLOR: "C000C0",
        LOGOIMG: "https://example.com/logo.png"
      }
    )
    response = express_request.setup(
      payment_request,
      'http://localhost:9393/success',
      'http://localhost:9393/cancel',
      paypal_options  # Optional
    )
    ap response.token
    ap response
  end
end
