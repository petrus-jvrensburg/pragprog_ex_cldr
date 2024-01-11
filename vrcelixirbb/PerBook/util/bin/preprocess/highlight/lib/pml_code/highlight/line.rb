# encoding: utf-8

class PmlCode
  class Highlight
    class Line

      attr_reader :has_id, :callout, :is_numbered

      def initialize(tokens, options)
        @options = options
        if options["verbatim"] == "yes"
          @tokens = tokens
        else
          tokens = merge_comments(tokens)
          @tokens = strip_special_comments(tokens) 
        end
      end

      def each(&block)
        @tokens.each(&block)
      end

      def start_highlight?
        @highlight_changer && @highlight_change
      end

      def end_highlight?
        @highlight_changer && !@highlight_change
      end

      def leading_spaces
        spaces = 0
        seen_non_space = false
        @tokens.each do |text, kind|
          next if text.kind_of?(String) && text.length == 0

          if kind == :space
            spaces += text.length
          else
            if text.kind_of?(String) && text =~ /^(\s+)/
              spaces += $1.length
            end
            seen_non_space = true
            break
          end
        end
        seen_non_space ? spaces : 9999
      end

      def strip_leading_spaces(count)
        to_strip = Regexp.new("^" + (" " * count))
        text, kind = @tokens.first

        if text.kind_of?(String)
          if text.sub!(to_strip, '')
            @tokens.first[0] = text
          end
          if text.empty?
            @tokens.shift
          end
        end
      end

      def empty?
        @tokens.empty?
      end

      def length
        result = 0
        @tokens.each do |text, kind|
          result += text.length if text.kind_of?(String)
        end
        result
      end

      def without_literals
        text.gsub(%r{<literal:.*?>}, '').gsub(%r{</literal:.*?>}, '')
      end

      def text
        result = []
        @tokens.each do |text, kind|
          result << text if text.kind_of?(String)
        end
        result.join
      end

      private

      def merge_comments(tokens)
        result = []
        state = :normal
        comment = []

        tokens.each do |text, kind|
          case state
          when :normal
            if kind == :comment
              state = :in_comment
              comment = [ text ]
            else
              result << [text, kind]
            end

          when :in_comment
            if kind == :comment || kind == :space
              comment << text
            else
              result << [ comment.join(""), :comment ]
              result << [ text, kind ]
              state = :normal
            end
          end

        end

        if state == :in_comment
          result << [ comment.join(""), :comment ]
        end

        result
      end

      def strip_special_comments(tokens)
        res = []
        # STDERR.puts tokens.inspect
        tokens.each do |text, kind|
          skip = false

          case
          when  kind == :comment
            if text =~ /(START|END)_HIGHLIGHT/
              @highlight_changer = true
              @highlight_change  = $1 == "START"
              skip = true
            elsif text.sub!(%r{<(label|callout)\s+id=('|")(.*?)\2\s*/>}, '')
              @has_id = $3 unless @options['add-id'] == "no"
              if $1 == 'callout'
                @callout = $1
              else
                @is_numbered = true
              end
              skip = text !~ /\w/
            end

          when text =~ /#\s*(START|END)_HIGHLIGHT/
              @highlight_changer = true
              @highlight_change  = $1 == "START"
              skip = true
          end

          res << [text, kind] unless skip
        end
        res
      end
    end
  end
end
