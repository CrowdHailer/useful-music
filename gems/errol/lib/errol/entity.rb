module Errol
  class Entity
    RepositoryUndefined = Class.new(StandardError)
    NilRecord = Class.new(StandardError)
    def self.repository=(repository)
      @repository = repository
    end

    def self.repository
      @repository || (raise RepositoryUndefined, "No repository set for #{self.name}")
    end

    def self.entry_reader(*entries)
      entries.each do |entry|
        define_method entry do
          record.public_send entry
        end
      end
    end

    def self.entry_writer(*entries)
      entries.each do |entry|
        define_method "#{entry}=" do |value|
          record.public_send "#{entry}=", value
        end
      end
    end

    def self.boolean_query(*entries)
      entries.each do |entry|
        define_method "#{entry}?" do
          !!(record.public_send entry)
        end
      end
    end

    def self.entry_accessor(*entries)
      entry_reader *entries
      entry_writer *entries
    end

    def self.boolean_accessor(*entries)
      boolean_query *entries
      entry_writer *entries
    end

    def initialize(record)
      # raise NilRecord, "Tried to initialise #{self.class.name} with nil record" if record.nil?
      @record = record
    end

    attr_reader :record
    protected :record
    entry_reader :id

    def set(**attributes)
      attributes.each do |attribute, value|
        self.public_send "#{attribute}=", value
      end
      self
    end

    def set!(*args)
      set(*args)
      save
    end

    def repository
      self.class.repository
    end

    def save
      repository.save self
      self
    end

    def destroy
      repository.remove self
      self
    end

    def refresh
      repository.refresh self
      self
    end

    def ==(other)
      other.class == self.class && other.record == record
    end
    alias_method :eql?, :==
    # def method_missing(method_name, *args, &block)
    #   if method_name.to_s =~ /^(.+)!$/
    #     self.public_send($1, *args, &block)
    #     repository.save self
    #   else
    #     super
    #   end
    # end

    # def respond_to?(method_name)
    #   if method_name.to_s =~ /^(.+)!$/
    #     self.respond_to? $1
    #   else
    #     super
    #   end
    # end

  end
end
