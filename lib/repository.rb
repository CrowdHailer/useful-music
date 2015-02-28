module Errol
  class Repository

    class << self
      def empty?(query_params={})
        new(query_params).empty?
      end

      def count(query_params={})
        new(query_params).count
      end
    end

    def empty?
      @dataset.empty?
    end

    def count
      @dataset.count
    end

  end
end
