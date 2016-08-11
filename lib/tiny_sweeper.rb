require 'tiny_sweeper/brooms'
require 'tiny_sweeper/broom_closet'

module TinySweeper
  module ClassMethods
    def sweep(field_names, *broom_names, &sweeper)
      Array(field_names).each do |field_name|
        stop_if_we_have_seen_this_before!(field_name)
        warn_about_missing_brooms(broom_names)

        overrides_module.module_eval do
          define_method("#{field_name}=") do |value|
            if value
              cleaned_up = broom_names.inject(value) { |accum, broom_name|
                ::TinySweeper::Brooms.fetch(broom_name).call(accum)
              }
              cleaned_up = sweeper.call(cleaned_up) if sweeper
              super(cleaned_up)
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

    def warn_about_missing_brooms(brooms)
      brooms.each do |broom|
        unless ::TinySweeper::Brooms.has_broom?(broom)
          warn "TinySweeper doesn't have this broom: #{broom}"
        end
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
