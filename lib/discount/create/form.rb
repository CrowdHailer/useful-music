class Discount
  class Create
    class Form
      include Virtus.model

      attribute :code, String
      attribute :value, Float
      attribute :allocation, Integer
      attribute :customer_allocation, Integer
      attribute :start_datetime, DateTime
      attribute :end_datetime, DateTime

      def code
        (super || '').strip.upcase
      end

      def value
        decimal = super
        Money.new(decimal * 100) if decimal.is_a?(Float)
      end

      def allocation
        super.is_a?(Fixnum) ? super : nil
      end

      def customer_allocation
        super.is_a?(Fixnum) ? super : nil
      end

      def start_datetime
        super.is_a?(DateTime) ? super : nil
      end

      def end_datetime
        super.is_a?(DateTime) ? super : nil
      end

    end
  end
end
