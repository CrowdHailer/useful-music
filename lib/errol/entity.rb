module Errol
  class Entity
    def self.repository=(repository)
      define_method :repository do
        repository
      end

      define_singleton_method :repository do
        repository
      end
    end

    def self.entry_reader(*entries)
      delegate *entries, :to => :record
    end

    def self.entry_writer(*entries)
      entries = entries.map{ |entry| "#{entry}=" }
      delegate *entries, :to => :record
    end

    def self.boolean_query(*entries)
      entries.each do |entry|
        define_method "#{entry}?" do
          record.public_send :entry
        end
      end
    end

    # boolean_writer is entry writer

    def self.entry_accessor(*entries)
      entry_reader *entries
      entry_writer *entries
    end

    def self.boolean_accessor(*entries)
      entry_reader *entries
      entry_writer *entries
    end

    def initialize(record)
      @record = record
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

    #################################
    #
    #    Sequel inspired helper methods
    #
    ##################################

    def save
      repository.save self
    end

    def destory
      repository.delete self
    end

    def reload
      repository.reload self
    end

    ############ End ########################

    def method_missing(method_name, *args, &block)
      if method_name.to_s =~ /^(.+)!$/
        self.public_send($1, *args, &block)
        repository.save self
      else
        super
      end
    end

    def respond_to?(method_name)
      if method_name.to_s =~ /^(.+)!$/
        self.respond_to? $1
      else
        super
      end
    end

  end
end
