class Customer
  class Record < Sequel::Model(:customers)
    def initialize(*args, &block)
      super
      self.id ||= SecureRandom.uuid()
    end
  end
end
