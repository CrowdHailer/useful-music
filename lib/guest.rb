class Guest
  # TODO untested
  def initialize(session={})
    @session = session
    # @curreny_preference = session.fetch('currency_preference', 'GBP')
    # @shopping_basket =
  end

  attr_reader :session

  def shopping_basket
    shopping_basket = ShoppingBaskets[session['guest.shopping_basket']]
    return shopping_basket if shopping_basket
    shopping_basket = ShoppingBaskets.create
    session['guest.shopping_basket'] = shopping_basket.id
    shopping_basket
  end

  def currency_preference
    session['guest.currency_preference']
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
    nil
  end

  def country
    nil
  end
end
