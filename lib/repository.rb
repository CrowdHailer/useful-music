module Errol
  class Repository
    # TODO make repository have create and build methods
    # Allow repository to be swapped out only by changing Repository
    # class Query
    #   def initialize(options={})
    #     @options = options
    #   end
    #
    #   attr_accessor :options
    #
    #   def page
    #     defaults.fetch(:page, 1).to_i
    #   end
    #
    #   def page_size
    #     defaults.fetch(:page_size, 3).to_i
    #   end
    #
    #   def order
    #     defaults.fetch(:order, :id).to_sym
    #   end
    #
    #   def title
    #     defaults[:title]
    #   end
    #
    #   def levels
    #     defaults.fetch(:levels, [])
    #   end
    #
    #   def categories
    #     defaults.fetch(:categories, [])
    #   end
    #
    #   def instruments
    #     defaults.fetch(:instruments, [])
    #   end
    #
    # end

    class Page
      include Enumerable
      def initialize(record_set, query, &wrap)
        @record_set = record_set
        @query = query
        @wrap = wrap
      end

      attr_reader :record_set, :query, :wrap

      def records_page
        record_set.paginate(query.page, query.page_size)
      end

      def each
        records_page.each do |record|
          yield wrap.call(record)
        end
      end

      delegate :page_size,
               :page_count,
               :current_page,
               :first_page?,
               :last_page?,
               :next_page,
               :prev_page,
               :page_range,
               :to => :records_page
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

      def page(query_params={})
        new(query_params).page
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
      if query_params.is_a? Hash
        @query = Query.new query_params
      else
        @query = query_params
      end
    end

    def empty?
      dataset.empty?
    end

    def count
      dataset.count
    end

    def all
      # TODO interface wrap method to through error
      dataset.map &method(:wrap)
    end

    def page
      Page.new(dataset, @query, &method(:wrap))
    end

    def [](id)
      # TODO Use primary key
      record = dataset.first(:id => id)
      wrap(record) if record
    end

    def first
      record = dataset.first
      wrap(record) if record
    end

    def last
      record = dataset.last
      wrap(record) if record
    end

    attr_reader :query

    def dataset
      Piece::Record.order(@query.order)
      # TODO biz specific logic
      # possible Piece::Repository < Errol::Repository(Piece::Record)
    end
  end
end
