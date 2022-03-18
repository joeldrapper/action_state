module ActionState
  class Predicate
    attr_reader :result

    def initialize(record)
      @record = record
      @result = true
    end

    def excluding(*records)
      return self unless result

      @result = false if records.include?(@record)

      self
    end

    def where(**kwargs)
      return self unless @result

      @result = false if kwargs.any? { |k, v| !compare(v, @record.send(k)) }

      self
    end

    def not(**kwargs)
      return self unless @result

      @result = false if kwargs.any? do |k, v|
        attribute = @record.send(k)
        next true if attribute.nil? && !v.nil?
        compare(v, attribute)
      end

      self
    end

    def method_missing(method_name, *args, **kwargs, &block)
      return self unless @result

      @result = false unless @record.send("#{method_name}?", *args, **kwargs, &block)

      self
    end

    private

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
