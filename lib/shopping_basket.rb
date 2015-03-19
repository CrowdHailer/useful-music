class ShoppingBasket < Errol::Entity
  require_relative './shopping_basket/record'

  def purchases
    record.purchase_records.map{ |r| Purchase.new r }
  end

  def order
    order_record = record.order_record
    Order.new(order_record) if order_record
  end

  def discount
    return @discount if @discount
    if record.discount_record
      @discount = Discount.new record.discount_record
    else
      Discount.null
    end
  end

  def discount=(discount)
    @discount = discount
    if discount.nil?
      record.discount_record = discount
    else
      record.discount_record = discount.record
    end
  end

  def price
    [purchases_price - discount.value, Money.new(0)].max
  end

  def purchases_price
    purchases.map(&:price).reduce(Money.new(0), &:+)
  end

  def empty?
    number_of_purchases == 0
  end

  def number_of_licences
    purchases.map(&:quantity).reduce(0, &:+)
  end

  def number_of_purchases
    purchases.count
  end

  def last_revision_at
    purchases.map(&:updated_at).max
  end
end
