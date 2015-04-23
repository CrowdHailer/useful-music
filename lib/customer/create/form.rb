require_relative './validator'
class Customer
  class Create < Usecase::Interactor
    class Form
      include Virtus.model
      include Veto.model(Validator.new)

      attribute :first_name, String
      attribute :last_name, String
      attribute :email, String
      attribute :password, String
      attribute :password_confirmation, String, :reader => :private
      attribute :country, String
      attribute :terms_agreement, String, :reader => :private

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

      def password
        (super || '').strip
      end

      def password_confirmation
        (super || '').strip
      end

      def password_confirmed?
        password == password_confirmation
      end

      def terms_agreed?
        terms_agreement == 'on'
      end
    end
  end
end
