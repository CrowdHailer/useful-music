class Customer
  class Record < Sequel::Model(:customers)
    def initialize(*args, &block)
      super
      self.id ||= SecureRandom.uuid()
    end

    plugin :timestamps, :update_on_create=>true
  end
end
