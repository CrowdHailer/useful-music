module Errol
  class Repository
    require_relative './repository/query'

    class << self

      def query_class(query_class=nil)
        if query_class
          @query_class = query_class
        else
          @query_class
        end
      end

      def record_class(record_class=nil)
        if record_class
          @record_class = record_class
        else
          @record_class || raise(ArgumentError)
        end
      end

      def entity_class(entity_class=nil)
        if entity_class
          @entity_class = entity_class
        else
          @entity_class || raise(ArgumentError)
        end
      end

      def build(attributes={})
        entity = entity_class.new(record_class.new)
        entity = entity.set attributes
        yeild entity if block_given?
        entity
      end
      #
      # def build_many(collection, &block)
      #   collection.map{|i| build i, &:block}
      # end

      def save(item)
        item.record.save
        self
      end

      def destroy(item)
        item.record.destroy
        self
      end

      def create(attributes, &block)
        build(attributes, &block).tap(&method(:save))
      end

      # TODO nice error for missing query
      def empty?(query_params={})
        new(query_params).empty?
      end

      def count(query_params={})
        new(query_params).count
      end

      # find uses paginate
      # [](id) => find(id, paginate => false)
      def [](id, query_params={})
        new(query_params)[id]
      end

      def fetch(id)
        item = self.[](id)
        unless item
          return yield id
        end
        item
      end

      def first(query_params={})
        new(query_params).first
      end

      def last(query_params={})
        new(query_params).last
      end

      def all(query_params={})
        new(query_params).all
      end
    end

    attr_reader :query
    delegate :page_size,
             :page_count,
             :current_page,
             :first_page?,
             :last_page?,
             :next_page,
             :prev_page,
             :page_range,
             :to => :records_page

    def initialize(query_params={})
      @query = self.class.query_class.new query_params
    end

    def empty?
      dataset.empty?
    end

    def count
      dataset.count
    end

    def [](id)
      # TODO Use primary key
      record = dataset.first(:id => id)
      implant(record) if record
    end

    def first
      record = dataset.first
      implant(record) if record
    end

    def last
      record = dataset.last
      implant(record) if record
    end

    def all
      # TODO interface implant method to through error
      records_page.map &method(:implant)
    end

    def each
      # TODO test
      # TODO uses page unless pagination false
      records_page.each do |record|
        yield implant(record)
      end
    end

    def dataset
      self.class.record_class.dataset
    end

    def records_page
      dataset.paginate(query.page, query.page_size)
    end


  end
end
