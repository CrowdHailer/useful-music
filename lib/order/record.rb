Dir[File.expand_path('../**/*.rb', __FILE__)].each { |file| require file }

class LicenseUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  # def extension_white_list
  #   %w(mp3)
  # end

  def store_dir
    super + "/licenses"
  end

  def filename
    "#{model.id}.pdf" if file
  end

end
class Order
  class Record < Sequel::Model(:orders)
    def initialize(*args, &block)
      super
      self.id ||= '%08d' % rand(1...(10 ** 8))
      # self.id ||= SecureRandom.uuid()
    end

    many_to_one :shopping_basket_record, :class => :'ShoppingBasket::Record', :key => :shopping_basket_id
    many_to_one :customer_record, :class => :'Customer::Record', :key => :customer_id

    plugin :timestamps, :update_on_create => true

    plugin :serialization

    serialize_attributes [
      lambda{ |money| money.fractional },
      lambda{ |fractional| Money.new(fractional) }
    ], :basket_amount, :tax_amount, :discount_amount

    mount_uploader :license, LicenseUploader
  end
end
