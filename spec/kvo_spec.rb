require File.join(File.dirname(__FILE__),'helper')

describe 'kvo' do
  before do
    @target = Foo.new
    @target.bar = :old

    @fired = nil
    @target.when :bar_changed do |old, new|
      @fired = {:old => old, :new => new}
    end
  end

  it 'notifies on setting of same value' do
    old_val = @target.bar
    @target.bar = old_val
    @fired.should_not be_nil
    @fired[:old].should == old_val
    @fired[:new].should == old_val
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

class Foo
  include Kvo
  kvo_attr_accessor :bar, :baz
end

class SubFoo < Foo
  kvo_attr_accessor :qux
end
