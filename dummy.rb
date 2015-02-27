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

# puts A.new('x').greet

begin
  begin
    1/0
  rescue ZeroDivisionError => e
    raise StandardError
  end
rescue StandardError => e
  puts e.cause
end

# puts A.const_defined? :B
# puts A.methods.select { |n| n[/^cons/]}


module A
  class C
  end
  module B
    class C
    end
    class D
      def self.c
        puts Module.nesting.find{|x| x.const_defined? :C}
        puts const_defined? :C
      end
    end
  end
end

puts A::B::D.c
