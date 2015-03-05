require_relative '../test_config'

class Order
  class RecordTest < MyRecordTest
    def test_has_an_id
      record = create :order_record
      assert_match(/.{8}/, record.id)
    end

    def test_requires_a_state
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :order_record, :state => nil
      end
      assert_match(/state/, err.message)
    end

    ['pending', 'processing', 'succeded', 'failed'].each do |state|
      define_method "test_can_be_in_allowed_state_#{state}" do
        record = create :order_record, :state => state
        assert_equal state, record.state
      end
    end

    def test_requires_permitted_state_state
      err = assert_raises Sequel::CheckConstraintViolation do
        create :order_record, :state => 'no_state'
      end
      assert_match(/allowed_states/, err.message)
    end

    def zero_pounds
      Money.new(0)
    end

    def test_can_have_zero_basket_amount
      record = create :order_record, :basket_amount => zero_pounds
      assert_equal zero_pounds, record.basket_amount
    end

    def test_can_have_maximum_basket_amount
      record = create :order_record, :basket_amount => Money.new(99999)
      assert_equal Money.new(99999), record.basket_amount
    end

    def test_basket_amount_cannot_be_negative
      err = assert_raises Sequel::CheckConstraintViolation do
        create :order_record, :basket_amount => Money.new(-1)
      end
      assert_match(/basket_amount_limit/, err.message)
    end

    def test_basket_amount_cannot_be_1000_pounds
      err = assert_raises Sequel::CheckConstraintViolation do
        create :order_record, :basket_amount => Money.new(100000)
      end
      assert_match(/basket_amount_limit/, err.message)
    end

    def test_can_have_zero_tax_amount
      record = create :order_record, :tax_amount => zero_pounds
      assert_equal zero_pounds, record.tax_amount
    end

    def test_can_have_maximum_tax_amount
      record = create :order_record, :tax_amount => Money.new(99999)
      assert_equal Money.new(99999), record.tax_amount
    end

    def test_tax_amount_cannot_be_negative
      err = assert_raises Sequel::CheckConstraintViolation do
        create :order_record, :tax_amount => Money.new(-1)
      end
      assert_match(/tax_amount_limit/, err.message)
    end

    def test_tax_amount_cannot_be_1000_pounds
      err = assert_raises Sequel::CheckConstraintViolation do
        create :order_record, :tax_amount => Money.new(100000)
      end
      assert_match(/tax_amount_limit/, err.message)
    end

    def test_can_have_zero_discount_amount
      record = create :order_record, :discount_amount => zero_pounds
      assert_equal zero_pounds, record.discount_amount
    end

    def test_can_have_maximum_discount_amount
      record = create :order_record, :discount_amount => Money.new(99999)
      assert_equal Money.new(99999), record.discount_amount
    end

    def test_discount_amount_cannot_be_negative
      err = assert_raises Sequel::CheckConstraintViolation do
        create :order_record, :discount_amount => Money.new(-1)
      end
      assert_match(/discount_amount_limit/, err.message)
    end

    def test_discount_amount_cannot_be_1000_pounds
      err = assert_raises Sequel::CheckConstraintViolation do
        create :order_record, :discount_amount => Money.new(100000)
      end
      assert_match(/discount_amount_limit/, err.message)
    end

    def test_can_have_payer_email
      record = create :order_record, :payer_email => 'string'
      assert_equal 'string', record.payer_email
    end

    def test_can_have_payer_first_name
      record = create :order_record, :payer_first_name => 'string'
      assert_equal 'string', record.payer_first_name
    end

    def test_can_have_payer_last_name
      record = create :order_record, :payer_last_name => 'string'
      assert_equal 'string', record.payer_last_name
    end

    def test_can_have_payer_company
      record = create :order_record, :payer_company => 'string'
      assert_equal 'string', record.payer_company
    end

    def test_can_have_payer_status
      record = create :order_record, :payer_status => 'string'
      assert_equal 'string', record.payer_status
    end

    def test_can_have_payer_identifier
      record = create :order_record, :payer_identifier => 'string'
      assert_equal 'string', record.payer_identifier
    end

    def test_can_have_token
      record = create :order_record, :token => 'string'
      assert_equal 'string', record.token
    end

    def test_can_have_transaction_id
      record = create :order_record, :transaction_id => 'string'
      assert_equal 'string', record.transaction_id
    end

    def test_requires_customer_record
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :order_record, :customer_record => nil
      end
      assert_match(/customer_id/, err.message)
    end

    def test_requires_shopping_basket_record
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :order_record, :shopping_basket_record => nil
      end
      assert_match(/shopping_basket_id/, err.message)
    end

  end
end
