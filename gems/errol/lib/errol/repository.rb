module Errol
  class Repository
    RecordAbsent = Class.new(StandardError)

    class << self
      def build(entries={})
        entity = dispatch(record_class.new)
        entries.each do |attribute, value|
          entity.public_send "#{attribute}=", value
        end
        yield entity if block_given?
        entity
      end

      def create(*arguments, &block)
        build(*arguments, &block).tap(&method(:save))
      end

      def save(entity)
        receive(entity).save
        self
      end

      def remove(entity)
        begin
          receive(entity).destroy
        rescue Sequel::NoExistingObject
          raise RecordAbsent
        end
        self
      end

      def empty?(requirements={})
        new(requirements, false).empty?
      end

      def count(requirements={})
        new(requirements, false).count
      end

      def first(requirements={})
        new(requirements, false).first
      end

      def last(requirements={})
        new(requirements, false).last
      end

      def [](id, requirements={})
        new(requirements, false)[id]
      end

      def fetch(id, requirements={}, &block)
        new(requirements, false).fetch(id, &block)
      end

      def all(requirements={})
        new(requirements, false).all
      end

      def each(requirements={}, &block)
        new(requirements, false).each &block
      end

      def raw_dataset
        record_class.dataset
      end
    end

    include Enumerable

    def initialize(requirements={}, paginate=true)
      @requirements = requirements
      @inquiry = self.class.inquiry(requirements)
      @paginate = paginate
    end

    def current_page
      paginated_dataset.current_page
    end

    def page_size
      paginated_dataset.page_size
    end

    def first_page?
      paginated_dataset.first_page?
    end

    def last_page?
      paginated_dataset.last_page?
    end

    def page_count
      paginated_dataset.page_count
    end

    def page_range
      paginated_dataset.page_range
    end

    def next_page
      paginated_dataset.next_page
    end

    def previous_page
      paginated_dataset.prev_page
    end

    attr_reader :inquiry

    def empty?
      paginated_dataset.empty?
    end

    def count
      paginated_dataset.count
    end

    def first
      dispatch(paginated_dataset.first)
    end

    def last
      # TODO say what!!
      all.last
      # dispatch(paginated_dataset.last)
    end

    def [](id)
      dispatch(dataset.first(:id => id))
    end

    def fetch(id)
      item = dispatch(dataset.first(:id => id))
      return item if item
      return yield id if block_given?
      record_absent(id)
    end

    def all
      paginated_dataset.map { |record| dispatch(record) }
    end

    def each
      paginated_dataset.each do |record|
        yield dispatch(record)
      end
      self
    end

    def raw_dataset
      self.class.raw_dataset
    end

    def paginate?
      @paginate
    end

    private

    def dispatch(item)
      self.class.dispatch(item) if item
    end

    def record_absent(id)
      raise RecordAbsent, "#{self.class.name} contains no record with id: #{id}"
    end

    def paginated_dataset
      if paginate?
        dataset.paginate(inquiry.page.to_i, inquiry.page_size.to_i)
      else
        dataset
      end
    end
  end
end
