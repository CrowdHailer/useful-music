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
          record.public_send entry
        end
      end
    end

    # boolean_writer is entry writer
    # query uses !!
    # reader adds ? but does not use !!

    def self.entry_accessor(*entries)
      entry_reader *entries
      entry_writer *entries
    end

    def self.boolean_accessor(*entries)
      boolean_query *entries
      entry_writer *entries
    end

    def initialize(record)
      raise NilRecord, "Tried to initialise #{self.class.name} with nil record" if record.nil?
      # TODO test
      @record = record
    end

    def repository
      self.class.repository
    end

    attr_reader :record
    entry_reader :id

    def set(**attributes)
      attributes.each do |attribute, value|
        self.public_send "#{attribute}=", value
      end
      self
    end

    def ==(other)
      other.class == self.class && other.record == record
    end
    alias_method :eql?, :==

    # #################################
    # #
    # #    helper methods, might belong in module
    # #
    # ##################################
    #
    def save
      repository.save self
    end

    def destroy
      repository.remove self
    end
    #
    # def reload
    #   repository.reload self
    # end

    ############ End ########################
    #

    def set!(*args)
      set(*args)
      save
    end
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
