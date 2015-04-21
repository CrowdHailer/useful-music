require_relative '../test_config'

class Customer
  class CreateTest < MyRecordTest
    include MailerTesting
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

    def test_successful_creation
      clear_mail
      usecase = Create.new({}, params)
      customer, = usecase.output
      assert usecase.created?
      assert_equal 'Mike Wasozki', customer.name
      assert_equal Customers.last, customer
      # TODO move mailer in context
      # assert_includes last_message.to, customer.email
    end

    def test_invalid_details_reports_form
      usecase = Create.new({}, params(:email => 'bad'))
      assert usecase.invalid_details?, "usecase reports #{usecase.outcome}"
      assert_equal ["is not valid"], usecase.output.first.errors.on(:email)
      assert_empty Customers
    end

    def test_returns_email_taken_correctly
      create :customer_record, :email => valid_params[:email]
      usecase = Create.new({}, params)
      form, = usecase.output
      assert usecase.email_taken?
      assert_equal ["is already taken"], form.errors.on(:email)
    end

  end
end
