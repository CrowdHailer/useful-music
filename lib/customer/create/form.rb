class Customer
  class Create
    class Form
      include Virtus.model

      attribute :first_name, String
      attribute :last_name, String
      attribute :email, String
      attribute :password, String
      attribute :password_confirmation, String, :reader => :private
      attribute :country, String

      delegate :each, :to => :to_hash

      def first_name
        (super || '').strip.capitalize
      end

      def last_name
        (super || '').strip.capitalize
      end

      def email
        (super || '').strip.downcase
      end

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
