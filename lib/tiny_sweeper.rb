module TinySweeper
  module ClassMethods
    def sweep(field_names, &sweeper)
      Array(field_names).each do |field_name|
        stop_if_we_have_seen_this_before!(field_name)

        overrides_module.module_eval do
          define_method("#{field_name}=") do |value|
            if value
              super(sweeper.call(value))
            else
              super(value)
            end
          end
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
  end

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  def sweep_up!
    self.class.sweep_up!(self)
  end
end
