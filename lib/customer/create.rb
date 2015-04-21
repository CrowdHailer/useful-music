class Customer
  class Create
  #   def initialize(context, params)
  #     @context = context
  #     @params = params
  #   end
  #
  #   def outcome
  #     validator = Validator.new
  #     return :invalid_details unless validator.valid?(form)
  #     # Customers.create form
  #     :created
  #     # :invalid_details
  #   end
  #
  #   def invalid_details
  #     yield form
  #   end
  #
  #   def form
  #     @form ||= Form.new(@params)
  #   end
  #   #
  #   # def invalid_details?
  #   #   true
  #   # end
  #   #
  #   # def email_taken?
  #   #   true
  #   # end
  end
end
