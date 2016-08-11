module TinySweeper
  module BroomCloset
    def self.blanks_to_nil(value)
      if value == ''
        nil
      else
        value
      end
    end

    def self.strip(value)
      value && value.strip
    end
  end

  BroomCloset.methods.each do |broom|
    Brooms.add(broom) { |value|
      BroomCloset.send(broom, value)
    }
  end
end
