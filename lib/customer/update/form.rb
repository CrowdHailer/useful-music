class Customer
  class Update
    class Form
      include Virtus.model

      attribute :first_name, String
      attribute :last_name, String
      attribute :email, String
      attribute :country, String
      attribute :question_1, String
      attribute :question_2, String
      attribute :question_3, String

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

      def question_1
        (super || '').strip
      end

      def question_2
        (super || '').strip
      end

      def question_3
        (super || '').strip
      end

    end
  end
end
