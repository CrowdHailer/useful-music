module A
  def self.new(*args, &block)
    Entity.new(*args, &block)
  end

  class Entity
    def initialize(name)
      @name = name
    end

    def greet
      "hello #{@name}"
    end
  end
end

puts A.new('x').greet

begin
  begin
    1/0
  rescue ZeroDivisionError => e
    raise StandardError
  end
rescue StandardError => e
  puts e.cause
end
