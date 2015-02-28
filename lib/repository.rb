module Errol
  class Repository
    class Query
      def initialize(options={})
        @options = options
      end

      attr_accessor :options

      def page
        options.fetch('page', 1).to_i
      end

      def page_size
        options.fetch('page_size', 3).to_i
      end

      def order
        options.fetch(:order, :id).to_sym
      end

      def title
        options[:title]
      end

      def levels
        options.fetch(:levels, [])
      end

    end

    class << self
      def empty?(query_params={})
        new(query_params).empty?
      end

      def count(query_params={})
        new(query_params).count
      end

      def all(query_params={})
        new(query_params).all
      end

      def [](id, query_params={})
        new(query_params)[id]
      end

      def first(query_params={})
        new(query_params).first
      end

      def last(query_params={})
        new(query_params).last
      end
    end

    def initialize(query_params={})
      query = Query.new query_params
      dataset = Piece::Record
      dataset = dataset.order(query.order)
      levels = query.levels
      if levels.count > 0
        levels.each_with_index do |level, i|
          dataset = i == 0 ? dataset.where(level) : dataset.or(level)
        end
      end
      dataset = dataset.where(:title => query.title) if query.title
      @dataset = dataset
    end

    def empty?
      @dataset.empty?
    end

    def count
      @dataset.count
    end

    def all
      # TODO interface wrap method to through error
      @dataset.map &method(:wrap)
    end

    def [](id)
      # TODO Use primary key
      record = @dataset.first(:id => id)
      wrap(record) if record
    end

    def first
      record = @dataset.first
      wrap(record) if record
    end

    def last
      record = @dataset.last
      wrap(record) if record
    end

  end
end
