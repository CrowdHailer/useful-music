require_relative '../test_config'

class Customer
  class EntityTest < MyRecordTest
    def customer
      @customer ||= Customer.new record
    end

    def record
      @record ||= OpenStruct.new
    end

    def teardown
      @customer = nil
      @record = nil
    end

    def test_authenticate_on_password_match
      record.password = BCrypt::Password.create('password')
      assert customer.correct_password?('password')
    end

    def test_password_will_not_check_without_match
      record.password = BCrypt::Password.create('password')
      refute customer.correct_password?('other')
    end

    def test_authenticates_if_correct_password
      customer.stub :correct_password?, true do
        assert_equal customer, customer.authenticate('password')
      end
    end

    def test_authenticate_returns_nil_if_password_incorect
      customer.stub :correct_password?, false do
        refute customer.authenticate('password')
      end
    end

    def test_records_a_login_on_successful_auth
      def test_authenticates_if_correct_password
        customer.stub :correct_password?, true do
          customer.authenticate('password')
        end
        assert customer.last_login_at
      end
    end

    def test_has_a_name
      record.first_name = 'Rob'
      record.last_name = 'Roy'
      assert_equal 'Rob Roy', customer.name
    end

    def test_is_not_a_guest
      refute customer.guest?
    end

    def test_is_not_an_admin
      refute customer.admin?
    end

    def test_can_be_an_admin
      record.admin = true
      assert customer.admin?
    end

    def test_is_a_customer
      assert customer.customer?
    end

    def test_survey_unanswered
      record.question_1 = ''
      assert customer.survey_unanswered?
    end

    def test_generates_reset_token
      skip
      customer.create_password_rest
    end

    ################# Associations #####################

    def test_has_orders
      order_record = create(:order_record)
      @record = order_record.customer_record
      assert_equal Order, customer.orders.first.class
    end


    ################# Archive #####################

    def test_can_access_first_name
      record.first_name = 'Rob'
      assert_equal 'Rob', customer.first_name
    end

    def test_can_set_first_name
      customer.first_name = 'Rob'
      assert_equal 'Rob', record.first_name
    end

    def test_can_access_last_name
      record.last_name = 'Roy'
      assert_equal 'Roy', customer.last_name
    end

    def test_can_set_last_name
      customer.last_name = 'Roy'
      assert_equal 'Roy', record.last_name
    end

    def test_can_access_email
      record.email = 'test@example.com'
      assert_equal 'test@example.com', customer.email
    end

    def test_can_set_email
      customer.email = 'test@example.com'
      assert_equal 'test@example.com', record.email
    end

    def test_can_access_password
      record.password = 'password'
      assert_equal 'password', customer.password
    end

    def test_can_set_password
      customer.password = 'password'
      assert_equal 'password', record.password
    end

    def test_can_access_country
      record.country = :uk
      assert_equal :uk, customer.country
    end

    def test_can_set_country
      customer.country = :uk
      assert_equal :uk, record.country
    end

    def test_can_access_question_1
      record.question_1 = :uk
      assert_equal :uk, customer.question_1
    end

    def test_can_set_question_1
      customer.question_1 = :uk
      assert_equal :uk, record.question_1
    end

    def test_can_access_question_2
      record.question_2 = :uk
      assert_equal :uk, customer.question_2
    end

    def test_can_set_question_2
      customer.question_2 = :uk
      assert_equal :uk, record.question_2
    end

    def test_can_access_question_3
      record.question_3 = :uk
      assert_equal :uk, customer.question_3
    end

    def test_can_set_question_3
      customer.question_3 = :uk
      assert_equal :uk, record.question_3
    end

    def test_can_access_last_login_at
      record.last_login_at = Time.at(200)
      assert_equal Time.at(200), customer.last_login_at
    end

    def test_can_set_last_login_at
      customer.last_login_at = Time.at(200)
      assert_equal Time.at(200), record.last_login_at
    end
  end
end
