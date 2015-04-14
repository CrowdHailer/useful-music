class Customer
  class UpdatePassword
    class Form
      include Virtus.model

      attribute :password, String
      attribute :password_confirmation, String, :reader => :private
      attribute :current_password, String

      def password
        (super || '').strip
      end

      def password_confirmation
        (super || '').strip
      end

      def current_password
        (super || '').strip
      end

      def password_confirmed?
        password == password_confirmation
      end

    end
  end
end
