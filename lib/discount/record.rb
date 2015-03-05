Dir[File.expand_path('../**/*.rb', __FILE__)].each { |file| require file }

class Discount
  class Record < Sequel::Model(:discounts)
    def initialize(*args, &block)
      super
      self.id ||= SecureRandom.urlsafe_base64
    end

    plugin :timestamps, :update_on_create=>true

    plugin :serialization

    serialize_attributes [
      lambda{ |money| money.fractional },
      lambda{ |fractional| Money.new(fractional) }
    ], :value

  end
end
