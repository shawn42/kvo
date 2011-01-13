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
end


class Foo
  include Kvo
  kvo_attr_accessor :bar, :baz
end
