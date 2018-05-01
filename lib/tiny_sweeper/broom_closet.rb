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
      value && value.strip.gsub("\u00A0", "")
    end

    def self.dumb_quotes(value)
      return nil if value.nil?

      # Stolen shamelessly from
      # https://github.com/yob/dumb_quotes/blob/master/lib/dumb_quotes/ar_extend.rb:

      # single quotes
      value = value.gsub("\xE2\x80\x98","'") # U+2018
      value = value.gsub("\xE2\x80\x99","'") # U+2019
      value = value.gsub("\xCA\xBC","'")     # U+02BC

      #  double quotes
      value = value.gsub("\xE2\x80\x9C",'"') # U+201C
      value = value.gsub("\xE2\x80\x9D",'"') # U+201D
      value = value.gsub("\xCB\xAE",'"')     # U+02EE

      value
    end
  end

  BroomCloset.methods.each do |broom|
    Brooms.add(broom) { |value|
      BroomCloset.send(broom, value)
    }
  end
end
