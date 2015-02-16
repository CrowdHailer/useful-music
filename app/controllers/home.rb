Paypal.sandbox!
class HomeController < UsefulMusic::App
  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/home'

  get '/' do
    render :index
  end

  get '/my-shopping-basket' do
    if session['useful_music.basket_id']
      basket = ShoppingBasket::Record[session['useful_music.basket_id']]
    else
      basket = ShoppingBasket::Record.create
      session['useful_music.basket_id'] = basket.id
    end
    redirect "/basket/#{basket.id}"
    # TODO move logic from this controller. redirect to new or show route
  end

  get '/b' do
    raise StandardError
  end

  get '/secure' do
    env['warden'].authenticate!
  end

  post '/pay' do
    paypal_options = {
      no_shipping: true, # if you want to disable shipping information
      allow_note: false, # if you want to disable notes
      pay_on_paypal: false # if you don't plan on showing your own confirmation step
    }

    request = Paypal::Express::Request.new(
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
    response = request.setup(
      payment_request,
      'http://localhost:9393/success',
      'http://localhost:9393/cancel',
      paypal_options  # Optional
    )
    redirect response.redirect_uri
  end

  get '/success' do
    new_request = Paypal::Express::Request.new(
      :username   => ENV.fetch('PAYPAL_USERNAME'),
      :password   => ENV.fetch('PAYPAL_PASSWORD'),
      :signature  => ENV.fetch('PAYPAL_SIGNATURE')
    )
    response = new_request.details(request.GET['token'])
    # ap request.GET
    # ap request.POST
    # ap response
    ap response.payer
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
    response = new_request.checkout!(
    request.GET['token'],
    request.GET['PayerID'],
      payment_request
    )

    ap response.payment_info
  end

end
