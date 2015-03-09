module Errol
  class Inquiry
    DefaultValueUndefined = Class.new(StandardError)

    def initialize(options={})
      options.each do |key, value|
        defaults[key.to_sym] = value
      end
    end

    def defaults
      @defaults ||= self.class.defaults.clone
    end

    def self.default(property, value)
      defaults[property.to_sym] = value
    end

    def self.defaults
      @defaults ||= {}
    end

    def method_missing(method_name, *args, &block)
      if method_name.to_s =~ /^(.+)(?:\?)$/
        !!self.public_send($1, *args, &block)
      else
        defaults.fetch(method_name) do |requirement|
          raise DefaultValueUndefined.new "Inquiry requirement for \"#{requirement}\" has not been set"
        end
      end
    end
  end
end
