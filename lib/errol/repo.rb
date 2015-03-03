module Errol
  class Repo
    class Query
      def initialize(options={})
        options.each do |key, value|
          defaults[key.to_sym] = value
        end
      end

      def defaults
        @defaults ||= self.class.defaults.clone
      end

      def self.default(property, value)
        defaults[property.to_sym] = value
      end

      def self.defaults
        @defaults ||= {:a => 'something'}
      end

      def method_missing(method)
        defaults.fetch(method)
      end
    end
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
