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
      report_invalid_details form unless form.valid?
      begin
        report_created Customers.create form
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
