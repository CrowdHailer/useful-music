module Errol
  # use wrap collection pass in paginated dataset
  class Repo
    
    class << self

      attr_accessor :record_class, :entity_class, :query

      def inherited(klass)
        # do set as constant
        klass.query = Class.new(Query)
      end

      def create(attributes, &block)
        build(attributes, &block).tap(&method(:save))
      end

      def save(item)
        item.record.save
        self
      end

      def build_many(collection, &block)
        collection.map{|i| build i, &:block}
      end

      def build(attributes={}, &block)
        entity_class
          .new(record_class.new)
          .set(attributes)
          .tap(&(block || ->(*_){}))
      end

      def alt_build(attributes={})
        entity = entity_class.new(record_class.new)
        entity = entity.set attributes
        yeild entity if block_given?
        entity
      end

      def empty?(query_params={})
        new(query_params).empty?
      end
    end

    def initialize(query_params={})
      @query = self.class.query.new query_params
    end

    def empty?
      dataset.empty?
    end


  end
end
