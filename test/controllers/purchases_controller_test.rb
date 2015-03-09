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
    assert_equal 1, Purchase::Record.last.quantity
  end

  def test_cant_create_purchase_without_item
    shopping_basket_record = create :shopping_basket_record
    post '/', :purchases => [:quantity => 1, :item => 1, :shopping_basket => shopping_basket_record.id]
    assert_equal 'Add items to shopping basket failed', flash['error']
  end
  
  def test_can_create_purchases
    item_record = create :item_record
    shopping_basket_record = create :shopping_basket_record
    post '/', :purchases => [:quantity => 2, :item => item_record.id, :shopping_basket => shopping_basket_record.id]
    post '/', :purchases => [:quantity => 4, :item => item_record.id, :shopping_basket => shopping_basket_record.id]
    assert_equal 6, Purchase::Record.last.quantity
  end

  def test_can_update_purchase
    purchase_record = create :purchase_record
    put "/#{purchase_record.id}", :purchase => {:quantity => 6}
    assert_equal 6, Purchase::Record.last.quantity
  end

  def test_cannot_update_purchase_to_negative
    purchase_record = create :purchase_record
    put "/#{purchase_record.id}", :purchase => {:quantity => -1}
    assert_equal purchase_record.quantity, Purchase::Record.last.quantity
    assert_equal 'Could not update basket', flash['error']
  end

  def test_cannot_update_nonexistant_purchase
    put "/21", :purchase => {:quantity => 2}
    assert_equal 'Could not update basket', flash['error']
  end

  def test_can_destroy_purchase
    purchase_record = create :purchase_record
    delete "/#{purchase_record.id}"
    assert_empty Purchase::Record
  end

  def test_cannot_destroy_nonexistant_purchase
    delete "/21"
    assert_equal 'Could not update basket', flash['error']
  end

end
