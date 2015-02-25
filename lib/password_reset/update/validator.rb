class PasswordReset
  class Update
    class Validator
      include Veto.validator

      def valid?(form)
        details = super
        if form.password_confirmed?
          confirmed = true
        else
          errors.add(:password_confirmation, 'does not match')
          confirmed = false
        end
        details && confirmed
      end

      validates :password,
        :presence => true,
        :min_length => 2,
        :max_length => 55
    end
  end
end
