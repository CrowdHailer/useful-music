class Customer
  class Create
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

      validates :first_name,
        :presence => true,
        :min_length => 2,
        :max_length => 26
      validates :last_name,
        :presence => true,
        :min_length => 2,
        :max_length => 26
      validates :email,
        :presence => true,
        :format => /^[^@]+@[^@]+$/
      validates :password,
        :presence => true,
        :min_length => 2,
        :max_length => 55
      validates :country,
        :presence => true
    end
  end
end
