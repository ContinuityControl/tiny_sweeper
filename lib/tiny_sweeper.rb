module TinySweeper
  module ClassMethods
    def sweep(field_name, &sweeper)
      stop_if_we_have_seen_this_before!(field_name)

      writer_method_name = writer_method_name(field_name)

      overrides_module.module_eval do
        define_method(writer_method_name) do |value|
          super(sweeper.call(value))
        end
      end
    end

    def sweep_up!(instance)
      @swept_fields.each do |field|
        instance.send("#{field}=", instance.send(field))
      end
    end

    private

    def overrides_module
      @overrides_module ||= begin
                              mod = Module.new
                              prepend mod
                              mod
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
