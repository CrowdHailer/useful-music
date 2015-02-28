module Errol
  class Repository

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
