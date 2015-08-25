class Customer
  class Create < AllSystems::Interactor
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
        if form.terms_agreed?
          agreed = true
        else
          errors.add(:terms_agreement, 'is not checked')
          agreed = false
        end
        details && confirmed && agreed
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
        :min_length => 8,
        :max_length => 55
      validates :country,
        :presence => true
    end
  end
end
