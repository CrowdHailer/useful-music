require_relative './base_entity'

class ShoppingBasket < BaseEntity
  def purchases
    record.purchase_records.map{ |r| Purchase.new r }
  end

  def price
    purchases.reduce(0){ |t, p| t + p.price}/100.0
  end
end
