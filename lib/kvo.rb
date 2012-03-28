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
          def #{kvo}=(newVal)
            old = @kvo_#{kvo}
            @kvo_#{kvo}=newVal
            fire :#{kvo}_changed, old, newVal
          end
        METHODS
      end
    end
  end

  def self.included(receiver)
    receiver.extend         Publisher
    receiver.extend         ClassMethods
  end
end
