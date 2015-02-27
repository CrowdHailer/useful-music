require_relative './base_entity'

class ShoppingBasket < BaseEntity
  def purchases
    record.purchase_records.map{ |r| Purchase.new r }
  end

  def order
    order_record = record.order_record
    Order.new(order_record) if order_record
  end

  def price
    purchases.map(&:price).reduce(Money.new(0), &:+)
  end

  def number_of_licenses
    purchases.map(&:quantity).reduce(0, &:+)
  end

  def number_of_purchases
    purchases.count
  end

  def last_revision_at
    purchases.map(&:updated_at).max
  end
end
