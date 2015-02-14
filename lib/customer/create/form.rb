class Customer
  class Create
    class Form
      include Virtus.model

      attribute :first_name, String
      attribute :last_name, String
      attribute :email, String
      attribute :password, String
      attribute :country, String

      delegate :each, :to => :to_hash
    end
  end
end
