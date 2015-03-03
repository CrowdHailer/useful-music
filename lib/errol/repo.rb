module Errol
  class Repo
    class << self

      attr_accessor :record_class, :entity_class

      def inherited(klass)
        klass.const_set :Query, :a
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

      def build(attributes, &block)
        entity_class
          .new(record_class.new)
          .set(attributes)
          .tap(&(block || ->(*_){}))
      end
    end

  end
end
