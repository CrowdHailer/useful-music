class Session
  class Create
    class Validator
      include Veto.validator

      validates :email,
        :presence => true,
        :format => /^[^@]+@[^@]+$/
      validates :password,
        :presence => true,
        :min_length => 2,
        :max_length => 55
    end
  end
end
