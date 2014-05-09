require 'claide/ansi'

class String
  # @return [StringEscaper] An object which provides convenience methods to
  #         wrap the receiver in ANSI sequences.
  #
  # @example
  #   "example".ansi.yellow #=> "\e[33mexample\e[39m"
  #   "example".ansi.on_red #=> "\e[41mexample\e[49m"
  #   "example".ansi.bold   #=> "\e[1mexample\e[21m"
  #
  def ansi
    CLAide::ANSI::StringEscaper.new(self)
  end
end

#-----------------------------------------------------------------------------#

module CLAide
  module ANSI
    # Provides support to wrap strings in ANSI sequences.
    #
    class StringEscaper
      # @param  [String] The string to wrap.
      #
      def initialize(string)
        @string = string
      end

      # @return [String] Wraps a string in the given ANSI sequences,
      #         taking care of handling existing sequences for the same
      #         family of attributes (i.e. attributes terminated by the
      #         same sequence).
      #
      def wrap_in_ansi_sequence(string, open, close)
        replaced = string.gsub(close, open)
        "#{open}#{replaced}#{close}"
      end

      ANSI::COLORS.each_key do |key|
        # Defines a method returns a copy of the receiver wrapped in an ANSI
        # sequence for each foreground color (e.g. #blue).
        #
        # The methods handle nesting of ANSI sequences.
        #
        define_method key do
          open = Graphics.foreground_color(key)
          close = ANSI::DEFAULT_FOREGROUND_COLOR
          wrap_in_ansi_sequence(@string, open, close)
        end

        # Defines a method returns a copy of the receiver wrapped in an ANSI
        # sequence for each background color (e.g. #on_blue).
        #
        # The methods handle nesting of ANSI sequences.
        #
        define_method "on_#{key}" do
          open = Graphics.background_color(key)
          close = ANSI::DEFAULT_BACKGROUND_COLOR
          wrap_in_ansi_sequence(@string, open, close)
        end
      end

      ANSI::TEXT_ATTRIBUTES.each_key do |key|
        # Defines a method returns a copy of the receiver wrapped in an ANSI
        # sequence for each text attribute (e.g. #bold).
        #
        # The methods handle nesting of ANSI sequences.
        #
        define_method key do
          open = Graphics.text_attribute(key)
          close_code = TEXT_DISABLE_ATTRIBUTES[key]
          close = Graphics.graphics_mode(close_code)
          wrap_in_ansi_sequence(@string, open, close)
        end
      end
    end
  end
end
