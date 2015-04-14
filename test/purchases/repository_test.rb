require_relative '../test_config'

class PurchasesTest < MyRecordTest
  def purchase_a
    @purchase_a ||= Purchase.new create(:purchase_record)
  end

  def purchase_b
    @purchase_b ||= Purchase.new create(:purchase_record)
  end

  def tear_down
    @purchase_a = nil
    @purchase_b = nil
  end

  def test_saves_purchase
    Purchases.save purchase_a
    refute_empty Purchases
  end

  def test_returns_purchases_in_a_basket
    assert_equal purchase_a, Purchases.all(:shopping_basket => purchase_a.shopping_basket).first
  end

  def test_returns_purchases_for_an_item
    assert_equal purchase_b, Purchases.all(:item => purchase_b.item).first
  end

  def test_filters_on_both
    assert_empty Purchases.all(:item => purchase_b.item, :shopping_basket => purchase_a.shopping_basket)
  end

end
