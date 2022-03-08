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

      @result = false if kwargs.any? do |k, v|
        case v
        when ::Range
          !v.cover? @record.send(k)
        when ::Enumerable
          !v.include? @record.send(k)
        else
          v != @record.send(k)
        end
      end

      self
    end

    def not(**kwargs)
      return self unless @result

      @result = false if kwargs.any? do |k, v|
        attribute = @record.send(k)
        next true if attribute.nil? && !v.nil?

        case v
        when ::Range
          v.cover? attribute
        when ::Enumerable
          v.include? attribute
        else
          v == attribute
        end
      end

      self
    end

    def method_missing(method_name, *args, **kwargs, &block)
      return self unless @result

      @result = false unless @record.send("#{method_name}?", *args, **kwargs, &block)

      self
    end
  end
end
