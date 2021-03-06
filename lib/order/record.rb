Dir[File.expand_path('../**/*.rb', __FILE__)].each { |file| require file }

class LicenceUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  # def extension_white_list
  #   %w(mp3)
  # end

  def store_dir
    super + "/licences"
  end

  def filename
    "useful-licence-#{model.id}.pdf" if file
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
    # many_to_one :discount_record, :class => :'Discount::Record', :left_primary_key => :shopping_basket_id, :right_primary_key => :discount_id, :join_table => :shopping_baskets
    def discount_record
      shopping_basket_record.discount_record
    end

    plugin :timestamps, :update_on_create => true

    plugin :serialization

    # serialize_attributes [
    #   lambda{ |money| money.fractional },
    #   lambda{ |fractional| Money.new(fractional) }
    # ], :basket_total, :tax_payment, :discount_value, :payment_gross, :payment_net

    def payment_net
      Money.new(super, currency)
    end

    def basket_total
      Money.new(super, currency)
    end

    def tax_payment
      Money.new(super, currency)
    end

    def discount_value
      Money.new(super, currency)
    end

    def payment_gross
      Money.new(super, currency)
    end

    def payment_net=(amount)
      super amount.fractional
    end

    def basket_total=(amount)
      super amount.fractional
    end

    def tax_payment=(amount)
      super amount.fractional
    end

    def discount_value=(amount)
      super amount.fractional
    end

    def payment_gross=(amount)
      super amount.fractional
    end

    serialize_attributes [
      lambda{ |currency| currency.iso_code },
      lambda{ |iso_code| Money::Currency.new(iso_code) }
    ], :currency

    mount_uploader :licence, LicenceUploader
  end
end
