class Guest
  def initialize(session)
    @session = session
  end

  attr_reader :session

  def save
    true
  end

  def shopping_basket
    ShoppingBaskets[session['guest.shopping_basket']]
  end

  def shopping_basket=(shopping_basket)
    session['guest.shopping_basket'] = shopping_basket.id
  end

  def currency_preference
    session['guest.currency_preference']
  end

  def working_currency
    currency_preference || 'GBP'
  end

  def currency_preference=(currency)
    # session['guest.currency_preference'] = currency.iso_code
    session['guest.currency_preference'] = currency
  end

  def id
    'GUEST'
  end

  def email
    'unknown@example.com'
  end

  def name
    'Guest user'
  end

  def guest?
    true
  end

  def customer?
    false
  end

  def admin?
    false
  end

  def id
    nil
  end

  def vat_rate
    0
  end

  def country
    nil
  end
end
