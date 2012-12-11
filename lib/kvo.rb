require 'publisher'
module Kvo
  module ClassMethods
    def kvo_attr_accessor(*kvo_symbols)
      kvo_symbols.each do |kvo|

        class_eval <<-METHODS
          can_fire :#{kvo}_changed unless published_events == :any_event_is_ok
          def #{kvo}
            @kvo_#{kvo}
          end
          def #{kvo}=(new_val)
            old = @kvo_#{kvo}
            @kvo_#{kvo}=new_val
            fire :#{kvo}_changed, old, new_val
          end
        METHODS
      end
    end
  end

  def kvo_bind_attr(attr_sym, target, opts={})
    target_attr = opts[:to] || attr_sym
    change_event = "#{attr_sym}_changed".to_sym

    unless self.class.published_events.include? change_event
      raise "#{attr_sym} is not a kvo attr; use #{self.class}.kvo_attr_accessor #{attr_sym}" 
    end
    
    self.when change_event do |old, new_val|
      val = new_val
      # transform
      val = yield(new_val) if block_given?

      target.send "#{target_attr}=", val
    end
  end

  def self.included(receiver)
    receiver.extend         Publisher
    receiver.extend         ClassMethods
  end
end
