class Customer
  class Update
    class Form
      include Virtus.model

      attribute :first_name, String
      attribute :last_name, String
      attribute :email, String
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

      def country
        Country.new(super)
      end
      
    end
  end
end
