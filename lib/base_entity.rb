class BaseEntity
  def initialize(record=self.class.record_klass.new)
    @record = record
  end

  def self.record_klass
    # TODO nice error for undefined Record
    # TODO look up one level so works for module
    self.const_get :Record
  end

  # TODO send only sends to public methods
  # TODO nice error for undefined
  def self.build(attributes={})
    new.tap do |entity|
      attributes.each do |attribute, value|
        entity.public_send "#{attribute}=", value
      end
    end
  end

  def self.create(*args)
    build(*args).record.save
  end

  def self.entry_accessor(*entries)
    delegate *entries.flat_map{|entry| [entry, "#{entry}="]}, :to => :record
  end

  def record
    @record
  end

  def id
    record.id
  end
end
