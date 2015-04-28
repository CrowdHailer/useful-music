class Customer < Errol::Entity
  require_relative './customer/record'
  entry_accessor  :first_name,
                  :last_name,
                  :email,
                  :password,
                  :country,
                  :currency_preference,
                  :question_1,
                  :question_2,
                  :question_3,
                  :last_login_at,
                  :password_reset_token,
                  :password_reset_created_at

  boolean_accessor :admin

  def repository
    Customers
  end

  def correct_password?(candidate_password)
    password == candidate_password
  end

  def authenticate(candidate_password)
    self if correct_password?(candidate_password) && record_login
  end

  def name
    Rack::Utils.escape_html "#{first_name} #{last_name}"
  end

  def email
    Rack::Utils.escape_html record.email
  end

  def question_1
    Rack::Utils.escape_html record.question_1
  end

  def question_2
    Rack::Utils.escape_html record.question_2
  end

  def question_3
    Rack::Utils.escape_html record.question_3
  end

  def guest?
    false
  end

  def customer?
    true
  end

  def orders
    record.order_records.map{ |r| Order.new r }
  end

  def shopping_basket
    shopping_basket_record = record.shopping_basket_record
    ShoppingBasket.new shopping_basket_record if shopping_basket_record
  end

  def shopping_basket=(shopping_basket)
    if shopping_basket.nil?
      record.shopping_basket_record = nil
    else
      record.shopping_basket_record = shopping_basket.record
    end
  end

  def survey_unanswered?
    (question_1.nil? || question_1.empty?) &&
    (question_2.nil? || question_2.empty?) &&
    (question_3.nil? || question_3.empty?)
  end

  def create_password_reset
    self.password_reset_created_at = Time.now
    self.password_reset_token = SecureRandom.urlsafe_base64
  end

  def vat_rate
    Country::EUVAT.new(self.country)
  end

  def working_currency
    currency_preference || Money::Currency.new('GBP')
  end

  private

  def record_login
    self.last_login_at = Time.now
  end
end
