class Session
  class Create
    class Form
      include Virtus.model

      attribute :email, String
      attribute :password, String

      def email
        (super || '').strip.downcase
      end

      def password
        (super || '').strip
      end
    end
  end
end
