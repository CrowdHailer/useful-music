class Purchase
  class Create
    class Batch
      def initialize(raw_forms)
        @forms = raw_forms.map{ |raw| Form.new raw }.reject(&:empty?)
      end

      attr_reader :forms
      delegate :each, :count, :to => :forms

      def valid?
        forms.all?(&:valid?)
      end

    end
  end
end
