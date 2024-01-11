# encoding: utf-8

class PmlCode
  class Highlight
    class Writer
 
      def initialize(lines, options, preprocessor)
        @options = options
        @lines   = lines
        @preprocessor = preprocessor
        @line_number       = 1
        @callout_number    = 1
        @highlighting      = false
        @numbering         = @lines.any?(&:is_numbered) || @options["forcenumber"] == "yes"
        @number_every_line = @numbering && @lines.size <= 10
      end

      def to_pml 
        res = [ ]
        @content_stack = []

        @lines.each do |line|
#STDERR.puts line.inspect
          if line.start_highlight?
            @highlighting = @options['highlight'] == 'yes'
          elsif line.end_highlight?
            @highlighting = false
          else

            res << start_codeline(line)
  
            line.each do | text, kind |
              if text == :open
                @content_stack.unshift(kind)
              elsif text == :close
                @content_stack.shift
              else
                case kind
                when :content, :delimiter, :inline_content, :inline_delimiter
                  kind = @content_stack[0]
                  redo
                when :reserved, :user_input, :directive, :tag, :type, :pre_type, :keyword
                  res << tag(:cokw, text)
                when :prompt
                  res << tag(:coprompt, text)
                when :string, :char
                  res << tag(:costring, text)
                when :comment
                  res << tag(:cocomment, text)
                else
                  # STDERR.puts "#{kind}: #{text.inspect}"
                  res << escape(text)
                end
              end
            end
            res << "</codeline>\n"
            @line_number += 1
          end
        end
        res.
          join.
          gsub(/&lt;literal:/, '<').
          gsub(/&lt;\/literal:/, '</').
          gsub(%r{</costring><costring>}, '').   # because delimiters get treated separately
          gsub(%r{<costring></costring>}, '')                                              

      end


      def start_codeline(line)
        line_options = {}

        add_line_number(line_options) if @numbering

        unless @options['verbatim'] == 'yes'
          line_options[:highlight] = 'yes' if @highlighting
          if line.has_id
            line_options[:id] = line.has_id
            if line.callout 
              line_options[:calloutno] = @callout_number
              @callout_number += 1
            else
              line_options[:lineno] = @line_number
            end
          end
        end

        if line.empty? && line_options.empty?
          line_options[:blank] = "yes"
        end

        # this is cheap     && this isn't
        if line.length > 84 && line.without_literals.length > 84
          @preprocessor.error("Code too wide: #{line.text.inspect}")
          line_options[:prefix]  = "!!!"
          line_options[:toolong] = "yes"
        end

        attributes = line_options.map {|k, v| %< #{k}="#{v}"> }.join
        "<codeline#{attributes}>"
      end


      def add_line_number(line_options)
        if @line_number == 1
          line_options[:prefix] = "Line 1"
        else
          if @number_every_line || (@line_number % 5).zero?
            line_options[:prefix] = @line_number.to_s
          else
            line_options[:prefix] = '-'
          end
        end
      end



      def tag(kind, text)
        %{<#{kind}>#{escape(text)}</#{kind}>}
      end

      def escape(text)
        text.gsub(/&/, '&amp;').gsub(/</, '&lt;').gsub(/\]\]>/, ']]&gt;');
      end
    end
  end
end
