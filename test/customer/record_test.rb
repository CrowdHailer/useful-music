require_relative '../test_config'

class Customer
  class RecordTest < MyRecordTest
    # Associations

    def test_can_have_multiple_orders
      record = create :customer_record
      2.times { record.add_order_record build(:order_record, :customer_record => nil) }
      assert_equal 2, record.order_records.count
    end

    def test_can_have_shopping_basket
      shopping_basket_record = create :shopping_basket_record
      record = create :customer_record, :shopping_basket_record => shopping_basket_record
      assert_equal shopping_basket_record, record.shopping_basket_record
    end

    def test_customers_cannot_have_the_same_basket
      shopping_basket_record = create :shopping_basket_record
      create :customer_record, :shopping_basket_record => shopping_basket_record
      assert_raises Sequel::UniqueConstraintViolation do
        create :customer_record, :shopping_basket_record => shopping_basket_record
      end
    end

    # Storage

    def test_has_an_id
      record = create :customer_record
      # Checks id has non negligable length
      assert_match(/.{8}/, record.id)
    end

    def test_requires_first_name
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :customer_record, :first_name => nil
      end
      assert_match(/first_name/, err.message)
    end

    def test_requires_last_name
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :customer_record, :last_name => nil
      end
      assert_match(/last_name/, err.message)
    end

    def test_requires_email
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :customer_record, :email => nil
      end
      assert_match(/email/, err.message)
    end

    def test_email_must_be_unique
      err = assert_raises Sequel::UniqueConstraintViolation do
        2.times{ create :customer_record, :email => 'test@example.com' }
      end
      assert_match(/email/, err.message)
    end

    def test_requires_password
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :customer_record, :password => nil
      end
      assert_match(/password/, err.message)
    end

    def test_crypts_password
      record = create :customer_record, :password => 'password'
      record.reload
      assert_equal record.password, 'password'
      refute_equal 'password', record.password
    end

    def test_requires_country
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :customer_record, :country => nil
      end
      assert_match(/country/, err.message)
    end

    def test_can_have_a_country
      record = create :customer_record
      assert_equal Country.new('GB'), record.country
    end

    def test_crypts_remember_token
      record = create :customer_record, :remember_token => 'remember'
      record.reload
      assert_equal record.remember_token, 'remember'
      refute_equal 'remember', record.remember_token
    end

    def test_crypts_reset
      record = create :customer_record, :password_reset_token => 'password_reset_token'
      record.reload
      assert_equal record.password_reset_token, 'password_reset_token'
      refute_equal 'password_reset_token', record.password_reset_token
    end

    def test_can_have_question_1
      record = create :customer_record, :question_1 => 'really'
      assert_equal 'really', record.question_1
    end

    def test_can_have_question_2
      record = create :customer_record, :question_2 => 'really'
      assert_equal 'really', record.question_2
    end

    def test_can_have_question_3
      record = create :customer_record, :question_3 => 'really'
      assert_equal 'really', record.question_3
    end

    def test_can_have_admin_status
      record = create :customer_record, :admin => true
      assert_equal true, record.admin
    end

    def test_can_have_currency_preference
      record = create :customer_record, :currency_preference => 'USD'
      assert_equal 'USD', record.currency_preference
    end

    def test_it_saves_time_of_creation
      Time.stub :now, Time.at(0) do
        record = create :customer_record
        assert_equal Time.at(0), record.created_at
        assert_equal Time.at(0), record.updated_at
      end
    end

    def test_it_save_update_time
      Time.stub :now, Time.at(0) do create :customer_record end
      record = Record.last
      record.update :email => 'new@test.com'
      refute_equal Time.at(0), record.updated_at
    end

    def test_it_can_save_last_login_at
      record = create :customer_record, :last_login_at => Time.at(200)
      assert_equal Time.at(200), record.last_login_at
    end
  end
end
