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

    def test_is_not_a_guest
      refute customer.guest?
    end

    def test_is_not_an_admin
      refute customer.admin?
    end

    def test_is_a_customer
      assert customer.customer?
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
