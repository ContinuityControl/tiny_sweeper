module CautiousSweeper
  module ClassMethods
    def sweep(field_name, &sweeper)
      @swept_fields ||= []
      @swept_fields << field_name

      writer_method_name = "#{field_name}=".to_sym

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
