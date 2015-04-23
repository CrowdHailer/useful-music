class Customer
  class Create < Usecase::Interactor
    def initialize(context, params)
      @context = context
      @params = params
    end

    attr_reader :context, :params

    def outcomes
      [:created, :invalid_details, :email_taken]
    end

    def run!
      begin
        report_invalid_details form unless form.valid?
        customer = Customers.create form

        report_created customer
      rescue Sequel::UniqueConstraintViolation => err
        form.errors.add(:email, 'is already taken')
        report_email_taken form
      end

    end

    def form
      @form ||= Form.new params
    end
  end
end
