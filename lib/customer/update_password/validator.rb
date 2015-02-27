class Customer
  class UpdatePassword
    class Validator
      include Veto.validator

      def initialize(record_password)
        @record_password = record_password
      end

      def valid?(form)
        details = super
        if form.password_confirmed?
          confirmed = true
        else
          errors.add(:password_confirmation, 'does not match')
          confirmed = false
        end
        if @record_password == form.current_password
          password_validated = true
        else
          errors.add(:current_password, 'is incorrect')
          password_validated = false
        end
        details && confirmed && password_validated
      end

      validates :password,
        :presence => true,
        :min_length => 2,
        :max_length => 55
    end
  end
end
