module CautiousSweeper
  def sweep(field_name, &sweeper)
    writer_method_name = "#{field_name}=".to_sym

    alias_method "original #{writer_method_name}", writer_method_name

    define_method(writer_method_name) do |value|
      clean_value = sweeper.call(value)
      send("original #{writer_method_name}", clean_value)
    end
  end
end

# Do it on all fields, by default? Or be explicit?
# TODO: add EagerSweeper, which loops over attributes
