require_relative './base_entity'

class Order < BaseEntity
  PAYPAL_OPTIONS = {
    no_shipping: true, # if you want to disable shipping information
    allow_note: false, # if you want to disable notes
    pay_on_paypal: true # if you don't plan on showing your own confirmation step
  }
  # TODO test
  entry_accessor  :state

  def initialize(*args)
    super
    self.state = 'pending'
  end

  def payment_request
    Paypal::Payment::Request.new(
      :currency_code => :GBP,
      :quantity      => 1,
      :amount => total + 1.50,
      :tax_amount => 1.50,
      :items => [{
        :name => 'Order Total',
        :amount => total,
        :category => :Digital
      }],
      :custom_fields => {
        CARTBORDERCOLOR: "01344C",
        LOGOIMG: "https://pbs.twimg.com/profile_images/508255387154268161/Xj42svTM_bigger.jpeg"
      }
    )
  end

  def express_request
    Paypal::Express::Request.new(
      :username   => ENV.fetch('PAYPAL_USERNAME'),
      :password   => ENV.fetch('PAYPAL_PASSWORD'),
      :signature  => ENV.fetch('PAYPAL_SIGNATURE')
    )
  end

  def setup
    express_response = express_request.setup(
      payment_request,
      "http://localhost:9393/orders/#{id}/success",
      "http://localhost:9393/orders/#{id}/cancel",
      PAYPAL_OPTIONS
    )
  end

  def fetch_details(token)
    express_response = express_request.details token
    payer = express_response.payer
    ap payer.email
    ap payer.first_name
    ap payer.last_name
    ap payer.company
    ap payer.status
    ap payer.identifier
  end

  def checkout(token, payer_id)
    express_response = express_request.checkout! token, payer_id, payment_request
    ap express_response.payment_info[0].transaction_id
    ap express_response.payment_info[0].payment_status
  end

  def total
    shopping_basket.price
  end

  def shopping_basket
    ShoppingBasket.new record.shopping_basket_record if record.shopping_basket_record
  end

  def shopping_basket=(shopping_basket)
    record.shopping_basket_record = shopping_basket.record
  end

  def customer
    Customer.new record.customer_record if record.customer_record
  end

  def customer=(customer)
    record.customer_record = customer.record
  end
end
