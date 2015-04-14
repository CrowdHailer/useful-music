class PasswordReset
  class Update
    class Form
      include Virtus.model

      attribute :password, String
      attribute :password_confirmation, String, :reader => :private

      def password
        (super || '').strip
      end

      def password_confirmation
        (super || '').strip
      end

      def password_confirmed?
        password == password_confirmation
      end

    end
  end
end
