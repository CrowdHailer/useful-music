require_relative './base_entity'

class ShoppingBasket < BaseEntity
  def purchases
    record.purchase_records.map{ |r| Purchase.new r }
  end
end
