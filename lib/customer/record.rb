class Customer
  class Record < Sequel::Model(:customers)
    def initialize(*args, &block)
      super
      self.id ||= SecureRandom.uuid()
    end

    plugin :timestamps, :update_on_create=>true
    plugin :serialization
    serialize_attributes [
      lambda{ |password| BCrypt::Password.create(password) },
      lambda{ |crypted| BCrypt::Password.new(crypted) }
    ], :password

  end
end
