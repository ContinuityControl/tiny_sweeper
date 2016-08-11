module TinySweeper
  module Brooms
    def self.add(broom_name, &block)
      (@brooms ||= {})[broom_name] = block
    end

    def self.has_broom?(broom_name)
      (@brooms ||= {}).has_key?(broom_name)
    end

    def self.fetch(broom_name)
      if has_broom?(broom_name)
        (@brooms ||= {})[broom_name]
      else
        raise MissingBroomException, broom_name
      end
    end
  end

  class MissingBroomException < ::StandardError
    def initialize(broom_name)
      super("TinySweeper doesn't have this broom: #{broom_name}")
    end
  end
end
