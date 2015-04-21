require_relative '../test_config'

class Customer
  class CreateTest < MyRecordTest
    def valid_params
      {
        :first_name => "Mike",
        :last_name => "Wasozki",
        :email => "test@example.com",
        :password => "password",
        :password_confirmation => "password",
        :country => 'GB',
        :terms_agreement => 'on'
      }
    end

    def params(extra={})
      valid_params.merge extra
    end

    # Reports
    #
    # def test_successful_creation
    #   usecase = Create.new({}, valid_params)
    #   assert_equal :created, usecase.outcome
    #   assert_equal 'Mike Wasozki', usecase.output.first.name
    # end

    # def test_doesnt_call_invalid_details_for_valid_params
    #   usecase = Create.new({}, valid_params)
    #   usecase.invalid_details do |form|
    #     flunk 'Should not action invalid details'
    #   end
    # end
    #
    # def test_reports_invalid_details_when_email_invalid
    #   usecase = Create.new({}, params(:email => 'bad'))
    #   assert_equal :invalid_details, usecase.outcome
    #   assert_equal 'bad', usecase.form.email
    #   usecase.invalid_details do |form|
    #     assert_equal form, usecase.form
    #   end
    # end

    # def test_reports_email_taken
    #   create :customer_record, :email => 'conflict@example.com'
    #   usecase = Create.new({}, {'email' => 'conflict@example.com'})
    #   assert_equal :email_taken, usecase.outcome
    # end
  end
end
