module TinySweeper
  module ClassMethods
    def sweep(field_name, &sweeper)
      stop_if_attribute_does_not_exist!(field_name)
      stop_if_we_have_seen_this_before!(field_name)

      writer_method_name = writer_method_name(field_name)

      alias_method "original #{writer_method_name}", writer_method_name

      define_method(writer_method_name) do |value|
        clean_value = sweeper.call(value)
        send("original #{writer_method_name}", clean_value)
      end
    end

    def sweep_up!(instance)
      @swept_fields.each do |field|
        instance.send("#{field}=", instance.send(field))
      end
    end

    private

    def stop_if_attribute_does_not_exist!(field_name)
      unless instance_methods(true).include?(writer_method_name(field_name))
        raise "There is no method named #{field_name.inspect} to sweep up!"
      end
    end

    def stop_if_we_have_seen_this_before!(field_name)
      @swept_fields ||= []

      if @swept_fields.include?(field_name)
        raise "Don't sweep #{field_name} twice!"
      end

      @swept_fields << field_name
    end

    def writer_method_name(field_name)
      "#{field_name}=".to_sym
    end
  end

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  def sweep_up!
    self.class.sweep_up!(self)
  end
end

# Do it on all fields, by default? Or be explicit?
# TODO: add EagerSweeper, which loops over attributes
