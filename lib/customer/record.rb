class Customer
  class Record < Sequel::Model(:customers)
    def initialize(*args, &block)
      super
      self.id ||= SecureRandom.uuid()
    end

    one_to_many :order_records, :class => :'Order::Record', :key => :customer_id

    plugin :timestamps, :update_on_create=>true
    plugin :serialization
    serialize_attributes [
      lambda{ |password| BCrypt::Password.create(password) },
      lambda{ |crypted| BCrypt::Password.new(crypted) }
    ], :password

  end
end
