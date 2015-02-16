class Customer
  class Create
    class Validator
      include Veto.validator

      validates :first_name, :presence => true
      validates :last_name, :presence => true
      validates :email, :presence => true
      validates :password, :presence => true
      validates :country, :presence => true
    end
  end
end
