# Look for \edd;m or \edd;ddm and map to <shade> tags with the appropriate color
# based on the ANSI escape sequences
#
# Note that \e is not a literal escape character, but the two characters \ and e


class AnsiColor < Preprocessor

  ESC_SEQ   = /(\\e(?:\d\d)(?:;(?:\d\d))?m)/

  OPEN_TAG  = "<literal:shade"
  CLOSE_TAG = "</literal:shade>"

  def map(line)
    if line =~ ESC_SEQ
      convert_colors(line)
    else
      line
    end
  end

  def convert_colors(line)
    shader = Shader.new
    result = []

    line = line.split(ESC_SEQ)

    line.shift if line.first == ""
    line.pop   if line.last == ""

    until line.empty?
      chunk = line.shift
      if chunk =~ /\\e(\d\d)(?:;(\d\d))?m/
        col1 = Integer($1)
        col2 = $2 ? Integer($2) : nil
        result << shader.maybe_change_colors(col1, col2)
      else
        result << chunk
      end
    end

    result << shader.close_shading

    result.join
  end

  
  # Helper class that keeps the current line state and which knows how
  # to generate our tags. Note that it assumes a white background and 
  # black foreground is the normal state

  class Shader

    BLACK = 0
    WHITE = 7
    BLACK_FG = 30 + BLACK
    WHITE_BG = 40 + WHITE

    COLOR_MAP = {
      0 => "black", 1 => "red", 2 => "green", 3 => "yellow", 4 => "blue", 5 => "magenta", 6 => "cyan", 7 => "black",
    }
    COLOR_MAP.default("INVALID COLOR")

    def initialize
      @fg = BLACK
      @bg = WHITE
      @in_shade = false
    end

    def maybe_change_colors(*colors)
      change = false
      result = []
      colors.compact.map(&:to_i).each do |color|
        fg_bg, color = color.divmod(10)
        case fg_bg
        when 3
          if @fg != color
            @fg = color
            change = true
          end
        when 4
          if @bg != color
            @bg = color
            change = true
          end
        else
          fail "Invalid color: #{color}"
        end
      end
      if change
        result << close_shading <<
                case
                when @fg == BLACK && @bg == WHITE
                  "" # noop
                when @fg == BLACK
                  @in_shade = true
                  %{#{OPEN_TAG} bg="#{COLOR_MAP[@bg]}">}
                when @bg == WHITE
                  @in_shade = true
                  %{#{OPEN_TAG} fg="#{COLOR_MAP[@fg]}">}
                else
                  @in_shade = true
                  %{#{OPEN_TAG} fg="#{COLOR_MAP[@fg]}" bg="#{COLOR_MAP[@bg]}">}
                end
      end
      result.join
    end

    def close_shading
      if @in_shade
        @in_shade = false
        CLOSE_TAG
      else
        ""
      end
    end

  end


end

__END__
given: plain text
  line 1
  line 2
expect:
  line 1
  line 2
given: a foreground change
  normal \e31mred\e30m normal
expect:
  normal <literal:shade fg="red">red</literal:shade> normal
given: a background change
  normal \e41mred\e47m normal
expect:
  normal <literal:shade bg="red">red</literal:shade> normal
given: a two adjacent foreground changes
  normal \e31mred\e32mgreen\e30m normal
expect:
  normal <literal:shade fg="red">red</literal:shade><literal:shade fg="green">green</literal:shade> normal
given: a foreground and background change
  normal \e31;42mshaded\e30;47m normal
expect:
  normal <literal:shade fg="red" bg="green">shaded</literal:shade> normal
given: a line that is not terminated
  normal \e31;42mshade
expect:
  normal <literal:shade fg="red" bg="green">shade</literal:shade>

