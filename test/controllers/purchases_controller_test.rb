require_relative '../test_config'

class PurchasesControllerTest < MyRecordTest
  include ControllerTesting

  def app
    PurchasesController
  end

  def test_can_create_purchase
    item_record = create :item_record
    shopping_basket_record = create :shopping_basket_record
    post '/', :purchases => [:quantity => 1, :item => item_record.id, :shopping_basket => shopping_basket_record.id]
  end

  def test_cant_create_purchase_without_item
    skip
    # item_record = create :item_record
    shopping_basket_record = create :shopping_basket_record
    post '/', :purchases => [:quantity => 1, :item => 1, :shopping_basket => shopping_basket_record.id]
  end

  def test_can_create_purchases
    item_record = create :item_record
    shopping_basket_record = create :shopping_basket_record
    post '/', :purchases => [:quantity => 1, :item => item_record.id, :shopping_basket => shopping_basket_record.id]
    post '/', :purchases => [:quantity => 1, :item => item_record.id, :shopping_basket => shopping_basket_record.id]
  end

end
