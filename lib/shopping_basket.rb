require_relative './base_entity'

class ShoppingBasket < BaseEntity
  def purchases
    record.purchase_records.map{ |r| Purchase.new r }
  end

  def price
    # TODO test
    purchases.reduce(0){ |t, p| t + p.price}/100.0
  end

  def number_of_licenses
    # TODO test
    purchases.reduce(0){ |sum, purchase| sum + purchase.quantity}
  end

  def number_of_items
    # TODO test
    purchases.count
  end
end
