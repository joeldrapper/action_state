module ActionState
  class Predicate
    def initialize(record)
      @record = record
      @match_refuted = false
    end

    def __matched__
      !@match_refuted
    end

    def excluding(*records)
      @match_refuted ||= records.include?(@record)
      self
    end

    def where(**kwargs)
      @match_refuted ||= kwargs.any? { |k, v| !compare(v, @record.send(k)) }
      self
    end

    def not(**kwargs)
      @match_refuted ||= kwargs.any? { |k, v| compare_with_nil_difference(v, @record.send(k)) }
      self
    end

    def method_missing(method_name, *args, **kwargs, &block)
      @match_refuted ||= !@record.send("#{method_name}?", *args, **kwargs, &block)
      self
    end

    private

    def compare_with_nil_difference(value, attribute_value)
      return true if attribute_value.nil? && !value.nil?
      compare(value, attribute_value)
    end

    def compare(value, attribute_value)
      case value
      when ::Range
        value.cover? attribute_value
      when ::Enumerable
        value.include? attribute_value
      else
        value == attribute_value
      end
    end
  end
end
