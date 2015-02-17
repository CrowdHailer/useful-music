class BaseEntity
  def initialize(record=self.class.record_klass.new)
    @record = record
  end

  def self.record_klass
    # TODO nice error for undefined Record
    # TODO look up one level so works for module
    # Module.nesting.find{|x| x.const_defined? :Record}.const_get :Record
    # Probably too magic.
    self.const_get :Record
  end

  # TODO send only sends to public methods
  # TODO nice error for undefined
  # TODO with block
  def self.build(attributes={})
    new.tap do |entity|
      attributes.each do |attribute, value|
        entity.public_send "#{attribute}=", value
      end
      yield entity if block_given?
    end
  end

  # TODO use tap
  def self.create(*args, &block)
    entity = build(*args, &block)
    entity.record.save
    entity
  end

  def self.entry_accessor(*entries)
    delegate(*entries.flat_map{|entry| [entry, "#{entry}="]}, :to => :record)
  end

  def record
    @record
  end

  # TODO nice error
  def id
    record.id
  end
end
