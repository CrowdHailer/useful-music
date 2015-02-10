class BaseEntity
  def initialize(record)
    @record = record
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
