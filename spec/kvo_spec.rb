require File.join(File.dirname(__FILE__),'helper')

describe '.kvo_attr_accessor' do
  before do
    @target = Foo.new
    @target.bar = :old

    @fired = nil
    @target.when :bar_changed do |old, new|
      @fired = {:old => old, :new => new}
    end
  end

  it 'does NOT notify on setting of same value' do
    @target.bar = @target.bar
    @fired.should be_nil
  end

  it 'notifies on setting of different value' do
    old_val = @target.bar
    @target.bar = :yar
    @fired.should_not be_nil
    @fired[:old].should == old_val
    @fired[:new].should == :yar
  end

  it 'is not available for direct setting' do
    @target.bar = :yar
    @target.instance_variable_get("@bar").should be_nil
  end

  it 'can call back a block of arity 0' do
    @baz_fired = nil
    @target.when :baz_changed do @baz_fired = true end
    @target.baz = :something
    @baz_fired.should be
  end

  describe "inheritance" do
    before do
      @target = SubFoo.new

      @fired = nil
      @target.when :bar_changed do |old, new|
        @fired = {:old => old, :new => new}
      end
      @target.when :qux_changed do |old, new|
        @qux_fired = {:old => old, :new => new}
      end
    end

    it 'inherits kvo from parent' do
      @target.bar = :old
      old_val = @target.bar
      @target.bar = :yar
      @fired.should_not be_nil
      @fired[:old].should == old_val
      @fired[:new].should == :yar
    end

    it 'can add more kvo fields to its parents fields' do
      @target.qux = :old

      old_val = @target.qux
      @target.qux = :yar
      @qux_fired.should_not be_nil
      @qux_fired[:old].should == old_val
      @qux_fired[:new].should == :yar
    end
  end
end

describe '#kvo_bind_attr' do
  let(:peter_pan) { 
    peter = PeterPan.new 
    peter.location = "OVER THERE"
    peter.flying = false
    peter
  }
  let(:shadow) { Shadow.new }

  it 'modifies attr when bound objects attr changes' do
    peter_pan.kvo_bind_attr :location, shadow
    peter_pan.location = "NEVERLAND"

    shadow.location.should == "NEVERLAND"
  end

  it 'can use a different method name on target' do
    peter_pan.kvo_bind_attr :location, shadow, to: :place

    peter_pan.location = "NEVERLAND"

    shadow.location.should be_nil
    shadow.place.should == "NEVERLAND"
  end

  it 'can transform new value with a block' do
    peter_pan.kvo_bind_attr :location, shadow do |new_value|
      new_value.downcase
    end
    peter_pan.location = "NEVERLAND"
    shadow.location.should == "neverland"
  end

  it 'can bind to non-kvo attrs (by making them kvo)' do
    lambda{ peter_pan.kvo_bind_attr :flying, shadow}.should raise_exception(RuntimeError, /flying is not a kvo attr/)
  end
end

class Foo
  include Kvo
  kvo_attr_accessor :bar, :baz
end

class SubFoo < Foo
  kvo_attr_accessor :qux
end

class PeterPan
  include Kvo
  kvo_attr_accessor :location
  attr_accessor :flying
end

class Shadow
  attr_accessor :location, :place, :flying
end

class ThingOne
  include Kvo
  attr_writer :one
end

class ThingTwo
  include Kvo
  attr_reader :two
end



