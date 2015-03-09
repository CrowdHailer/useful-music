class Purchase
  class Create
    class Batch
      # TODO Dependency inject Form can reuse
      def initialize(raw_forms)
        @forms = raw_forms.map{ |raw| Form.new raw }.reject(&:empty?)
      end

      attr_reader :forms
      delegate :each, :count, :to => :to_hash

      def valid?
        forms.all?(&:valid?)
      end

    end
  end
end
