require_relative '../test_config'

class Customer
  class RecordTest < MyRecordTest
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

    def test_requires_country
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :customer_record, :country => nil
      end
      assert_match(/country/, err.message)
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
