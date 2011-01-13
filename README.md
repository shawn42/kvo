Description
===========

Key-Value Observing in ruby

### Synopsis

Fires a [Publisher](http://atomicobject.github.com/publisher/) event whenever the variable is set.

### How do I use it?

class Foo
  include Kvo
  kvo_attr_accessor :bar, :baz
end
    
f = Foo.new
f.when :bar_changed do |oldVal, newVal|
end

Authors
=======
* Shawn Anderson (shawn.anderson@atomicobject.com)
