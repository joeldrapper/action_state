require "action_state/version"
require "action_state/railtie"
require "action_state/predicate"

module ActionState
  extend ActiveSupport::Concern

  class_methods do
    def state(name, &block)
      scope(name, Proc.new(&block))

      define_method("#{name}?") do |*args, **kwargs|
        Predicate.new(self).instance_exec(*args, **kwargs, &block).result
      end
    end
  end
end
