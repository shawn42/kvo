Description
===========

Key-Value Observing and Binding in ruby

### Synopsis

Fires a [Publisher](http://atomicobject.github.com/publisher/) event whenever the variable is set.

### How do I use it?

```ruby
    # kvo example 
    class Foo
      include Kvo
      kvo_attr_accessor :bar, :baz
    end

    f = Foo.new
    f.when :bar_changed do |oldVal, newVal|
      puts "bar was changed from #{oldVal} to #{newVal}"
    end


    # kvb example 
    class Baz
      attr_accessor :bar
    end
        
    b = Bar.new
    # b's bar will be updated whenever f's is
    f.kvo_bind_attr :bar, b

    # optional transforms
    f.kvo_bind_attr :bar, b do |val|
      val + 5
    end
```

Authors
=======
* Shawn Anderson (shawn.anderson@atomicobject.com)
