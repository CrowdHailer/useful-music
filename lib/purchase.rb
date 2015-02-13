require_relative './base_entity'

class Purchase < BaseEntity
  entry_accessor  :quantity

  def price
    item.initial_price + (item.subsequent_price * (quantity - 1))
    # item.price_for(quantity)
  end

  def item
    Item.new record.item_record if record.item_record
  end

  def item=(item)
    record.item_record = item.record
  end

  def shopping_basket
    ShoppingBasket.new record.shopping_basket_record if record.shopping_basket_record
  end

  def shopping_basket=(shopping_basket)
    record.shopping_basket_record = shopping_basket.record
  end

end
