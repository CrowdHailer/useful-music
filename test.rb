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
