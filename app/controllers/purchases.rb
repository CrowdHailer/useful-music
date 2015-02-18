# TODO move
class Purchase
  class Create
    class Form
      include Virtus.model
      attribute :quantity, Integer
      attribute :item, Integer
      attribute :shopping_basket, String
      delegate :each, :to => :to_hash

      def item
        Item.new(Item::Record[super])
      end

      def shopping_basket
        ShoppingBasket.new(ShoppingBasket::Record[super])
      end
    end
  end

  class CreateMany
    class Form
      include Virtus.model
      attribute :purchases, Array[Create::Form]

    end
  end
end
class PurchasesController < UsefulMusic::App
  include Scorched::Rest

  def create
    # TODO error tests
    form = Purchase::CreateMany::Form.new request.POST
    form.purchases.each do |create_form|
      begin
        Purchase.create create_form
      rescue Sequel::UniqueConstraintViolation => e
        purchase_record = Purchase::Record
          .where(:shopping_basket_id => create_form.shopping_basket.id)
          .where(:item_id => create_form.item.id)
          .first
        purchase_record.quantity += create_form.quantity
        purchase_record.save
      end
    end
  end

  def update(id)
    # TODO error tests
    purchase = Purchase.new(Purchase::Record[id])
    purchase.quantity = request.POST['purchase']['quantity']
    purchase.record.save
    flash[:success] = 'Shopping basket updated'
    redirect request.referer
  end

  def destroy(id)
    # TODO error tests
    purchase = Purchase.new(Purchase::Record[id])
    purchase.record.destroy
    flash[:success] = 'Item removed from basket'
    redirect request.referer
  end
end
