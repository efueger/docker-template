# Frozen-string-literal: true
# Copyright: 2015 Jordon Bedwell - Apache v2.0 License
# Encoding: utf-8

module Docker
  module Template
    module Ansi module_function
      Escape = "%c" % 27
      Match = /#{Escape}\[(?:\d+)(?:;\d+)?(j|k|m|s|u|A|B)|\e\(B\e\[m/ix.freeze
      Colors = { :red => 31, :green => 32, :black => 30, :magenta => 35,
        :yellow => 33, :white => 37, :blue => 34, :cyan => 36 }

      # Strip ANSI from the current string.  It also strips cursor stuff,
      # well some of it, and it also strips some other stuff that a lot of
      # the other ANSI strippers don't.

      def strip(str)
        str.gsub Match, ""
      end

      # Reset the vterm view if it's supported.  Depending on how badly
      # your vterm is implemented it might reset rather than clear scrollback
      # with a few empty lines added on the top.

      def clear
        $stdout.print("%c[H%c[2J" % [27, 27])
      end

      #

      def has?(str)
        !!(str =~ Match)
      end

      # Jump the cursor up and then back down or just up and down.  This is
      # useful when streaming async downloads from something like Docker.  It
      # also works better than using `tput`

      def jump(str = "", up: nil, down: nil, both: nil, clear: true)
        str = clear_line(str) if clear

        return "%c[%dA%s%c[%dB" % [27, up || both, str, 27, down || both] if (up && down) || both
        up ? "%c[%dA%s" % [27, up, str] : "%s%c[%dB" % [str, 27, down]
      end

      # Reset the color back to the default color so that you do not leak any
      # colors when you move onto the next line. This is probably normally
      # used as part of a wrapper so that we don't leak colors.

      def reset(str = "")
        @ansi_reset ||= "%c[0m" % 27
        "#{@ansi_reset}#{str}"
      end

      #

      def clear_line(str = "")
        @ansi_clear_line ||= "%c[2K\r" % 27
        "#{@ansi_clear_line}#{str}\r"
      end

      # SEE: `self::Colors` for a list of methods.  They are mostly
      # standard base colors supported by pretty much any xterm-color, we do
      # not need more than the base colors so we do not include them.
      # Actually... if I'm honest we don't even need most of the
      # base colors.

      Colors.each do |color, num|
        define_method color do |str|
          "#{"%c" % 27}[#{num}m#{str}#{reset}"
        end; module_function color
      end
    end
  end
end
