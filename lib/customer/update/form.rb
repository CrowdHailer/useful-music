class Customer
  class Update
    class Form
      include Virtus.model

      attribute :first_name, String
      attribute :last_name, String
      attribute :email, String
      attribute :country, String

      delegate :each, :to => :to_hash
    end
  end
end
