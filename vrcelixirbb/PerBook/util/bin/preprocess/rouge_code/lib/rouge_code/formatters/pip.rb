# -*- coding: utf-8 -*- #


TOKEN_TO_TAG = {
  Rouge::Token::Tokens::Text                           => nil,
  Rouge::Token::Tokens::Text::Whitespace               => nil,

  Rouge::Token::Tokens::Error                          => :cokw,

  Rouge::Token::Tokens::Other                          => nil,

  Rouge::Token::Tokens::Keyword                        => :cokw,
  Rouge::Token::Tokens::Keyword::Constant              => :cokw,   # 'kc'
  Rouge::Token::Tokens::Keyword::Declaration           => :cokw,   # 'kd'
  Rouge::Token::Tokens::Keyword::Namespace             => :cokw,   # 'kn'
  Rouge::Token::Tokens::Keyword::Pseudo                => :cokw,   # 'kp'
  Rouge::Token::Tokens::Keyword::Reserved              => :cokw,   # 'kr'
  Rouge::Token::Tokens::Keyword::Type                  => :cokw,   # 'kt'
  Rouge::Token::Tokens::Keyword::Variable              => :cokw,   # 'kv'

  Rouge::Token::Tokens::Name                           => nil,
  Rouge::Token::Tokens::Name::Attribute                => :cotag,  # 'na'
  Rouge::Token::Tokens::Name::Builtin                  => nil,     # 'nb'
  Rouge::Token::Tokens::Name::Builtin::Pseudo          => nil,     # 'bp'
  Rouge::Token::Tokens::Name::Class                    => nil,     # 'nc'
  Rouge::Token::Tokens::Name::Constant                 => nil,     # 'no'
  Rouge::Token::Tokens::Name::Decorator                => nil,     # 'nd'
  Rouge::Token::Tokens::Name::Entity                   => nil,     # 'ni'
  Rouge::Token::Tokens::Name::Exception                => nil,     # 'ne'
  Rouge::Token::Tokens::Name::Function                 => :cokw,   # 'nf'
  Rouge::Token::Tokens::Name::Property                 => nil,     # 'py'
  Rouge::Token::Tokens::Name::Label                    => nil,     # 'nl'
  Rouge::Token::Tokens::Name::Namespace                => :cokw,   # 'nn'
  Rouge::Token::Tokens::Name::Other                    => nil,     # 'nx'
  Rouge::Token::Tokens::Name::Tag                      => :cotag,  # 'nt'
  Rouge::Token::Tokens::Name::Variable                 => :cotag,  # 'nv'
  Rouge::Token::Tokens::Name::Variable::Class          => nil,     # 'vc'
  Rouge::Token::Tokens::Name::Variable::Global         => nil,     # 'vg'
  Rouge::Token::Tokens::Name::Variable::Instance       => nil,     # 'vi'

  Rouge::Token::Tokens::Literal                        => nil,        # 'l'
  Rouge::Token::Tokens::Literal::Date                  => nil,        # 'ld'

  Rouge::Token::Tokens::Literal::String                => :costring,        # 's'
  Rouge::Token::Tokens::Literal::String::Backtick      => :costring,        # 'sb'
  Rouge::Token::Tokens::Literal::String::Char          => :costring,        # 'sc'
  Rouge::Token::Tokens::Literal::String::Doc           => :costring,        # 'sd'
  Rouge::Token::Tokens::Literal::String::Double        => :costring,        # 's2'
  Rouge::Token::Tokens::Literal::String::Escape        => :costring,        # 'se'
  Rouge::Token::Tokens::Literal::String::Heredoc       => :costring,        # 'sh'
  Rouge::Token::Tokens::Literal::String::Interpol      => :costring,        # 'si'
  Rouge::Token::Tokens::Literal::String::Other         => :costring,        # 'sx'
  Rouge::Token::Tokens::Literal::String::Regex         => :costring,        # 'sr'
  Rouge::Token::Tokens::Literal::String::Single        => :costring,        # 's1'
  Rouge::Token::Tokens::Literal::String::Symbol        => :costring,        # 'ss'

  Rouge::Token::Tokens::Literal::Number                => nil,        # 'm'
  Rouge::Token::Tokens::Literal::Number::Float         => nil,        # 'mf'
  Rouge::Token::Tokens::Literal::Number::Hex           => nil,        # 'mh'
  Rouge::Token::Tokens::Literal::Number::Integer       => nil,        # 'mi'
  Rouge::Token::Tokens::Literal::Number::Integer::Long => nil,        # 'il'
  Rouge::Token::Tokens::Literal::Number::Oct           => nil,        # 'mo'
  Rouge::Token::Tokens::Literal::Number::Bin           => nil,        # 'mb'
  Rouge::Token::Tokens::Literal::Number::Other         => nil,        # 'mx'

  Rouge::Token::Tokens::Operator                       => nil,        # 'o'
  Rouge::Token::Tokens::Operator::Word                 => :cokw,      # 'ow'

  Rouge::Token::Tokens::Punctuation                    => nil,        # 'p'
  Rouge::Token::Tokens::Punctuation::Indicator         => nil,        # 'pi'

  Rouge::Token::Tokens::Comment                        => :cocomment, # 'c'
  Rouge::Token::Tokens::Comment::Doc                   => :cocomment, # 'cd'
  Rouge::Token::Tokens::Comment::Multiline             => :cocomment, # 'cm'
  Rouge::Token::Tokens::Comment::Preproc               => :cocomment, # 'cp'
  Rouge::Token::Tokens::Comment::Single                => :cocomment, # 'c1'
  Rouge::Token::Tokens::Comment::Special               => :cocomment, # 'cs'

  Rouge::Token::Tokens::Generic                        => nil,        # 'g'
  Rouge::Token::Tokens::Generic::Deleted               => nil,        # 'gd'
  Rouge::Token::Tokens::Generic::Emph                  => nil,        # 'ge'
  Rouge::Token::Tokens::Generic::Error                 => nil,        # 'gr'
  Rouge::Token::Tokens::Generic::Heading               => nil,        # 'gh'
  Rouge::Token::Tokens::Generic::Inserted              => :cokw,      # 'gi'
  Rouge::Token::Tokens::Generic::Output                => nil,        # 'go'
  Rouge::Token::Tokens::Generic::Prompt                => :coprompt,  # 'gp'
  Rouge::Token::Tokens::Generic::Strong                => nil,        # 'gs'
  Rouge::Token::Tokens::Generic::Subheading            => nil,        # 'gu'
  Rouge::Token::Tokens::Generic::Traceback             => nil,        # 'gt'
  Rouge::Token::Tokens::Generic::Lineno                => nil,        # 'gl'
}

module Rouge   # Yes, this _is_ in the Rouge namespace
  module Formatters

    # Transforms a token stream into HTML output.
    class Pip < Formatter
      tag 'pip'


      def initialize(opts={})
        @callout_number = 1
        Line.reset
        @preprocessor = opts[:preprocessor]
        @options      = opts[:options]
      end

      # @yield the html output.
      def stream(tokens, &b)
        lines = split_into_lines(tokens)
        lines.each do |line|
          next if line.is_elided?
          yield start_line_tag(line)
          line.each{ |tok, val| tag(tok, val, &b) }
          yield end_line_tag(line)
        end

        if @long_line_seen
          @preprocessor.error "Book contains code whose lines are too long"
        end
      end

      private


      def add_line_number(line, tag)
        if line.line_number == 1
          tag << %s{ prefix="Line 1"}
        else
          if line.code_block.number_every_line || (line.line_number % 5).zero?
            tag << %{ prefix="#{line.line_number}"}
          else
            tag << %s{ prefix='-'}
          end
        end
      end

      def start_line_tag(line)
        tag = [ "<codeline" ]

        unless @options['verbatim'] == 'yes'

          if line.highlight
            tag << %{ highlight="yes"}
          end

          if line.has_id
            tag << %{ id="#{line.has_id}"}
            if line.callout
              tag << %{ calloutno="#{@callout_number}"}
              @callout_number += 1
            else
              tag << %{ lineno="#{@line_number}"}
            end
          end
        end

        # this first part is fast
        if line.line_len > 84
          # then do it for real
          text = line.tokens.first.last.gsub(RougeCode::LITERAL_PROXY, '')

          if text.length > 84
            STDERR.puts text.inspect
            tag << %{ toolong="yes"}
            @long_line_seen = true
          end
        end

        add_line_number(line, tag) if line.code_block.number_lines

        tag << ">"

        tag.join
      end

      def end_line_tag(_line)
        "</codeline>\n"
      end

      def split_into_lines(tokens)
        lines = Lines.new(@options)

        tokens.each do |tok, val|
          if val["\n"]
            if val == "\n"
              lines.start_new_line
            else
              vals = val.split(/(\n)/)
              vals.each do |aval|
                case aval
                when ""
                  ;
                when "\n"
                  lines.start_new_line
                else
                  lines << [ tok, aval ]
                end
              end
            end
          else
            lines << [ tok, val ]
          end
        end

        lines.tidy_up
        lines
      end

      TABLE_FOR_ESCAPE_HTML = {
        '&' => '&amp;',
        '<' => '&lt;',
      }

      def tag(tag, val)
        return if tag == :elided_comment

        if val
          val = val
            .gsub(/[&<]/, TABLE_FOR_ESCAPE_HTML)
            .gsub(/]]>/, ']]&gt;')
        end

        if tag
          tag = tag.to_s
          tag = tag.sub(/literal:/, '')
          yield "<#{tag}>#{val}</#{tag}>"
        else
          yield val if val
        end

      end
    end
  end
end

##################
# Group of Lines #
##################

class Rouge::Formatters::Pip
  class Lines

    attr_accessor(:highlighting,
                  :number_lines,
                  :line_number,
                  :options)

    def initialize(options)
      @lines        = []
      @highlighting = false
      @number_lines = false
      @options      = options
      @line_number  = 0
      @current_line = new_line
    end

    def new_line
      @line_number += 1
      Line.new(self, @line_number)
    end

    def <<(tok_and_val)
      @current_line << tok_and_val
    end

    def start_new_line
      @lines << @current_line
      @current_line = new_line
    end

    def tidy_up
      unless @current_line.empty?
        @lines << @current_line
      end
    end

    def number_every_line
      @lines.size <= 10
    end

    def each
      @lines.each {|line| yield line}
    end
  end
end

########
# Line #
########

class Rouge::Formatters::Pip
  class Line
    attr_reader :callout
    attr_reader :code_block
    attr_reader :has_id
    attr_reader :highlight
    attr_reader :line_len
    attr_reader :line_number
    attr_reader :tokens

    class << self
      attr_accessor :highlighting

      def reset
        @highlighting = false
      end
    end

    def initialize(code_block, line_number)
      @code_block = code_block
      @tokens = []
      @highlight = @code_block.highlighting
      @line_number = line_number
      @line_len = 0
    end

    def <<(tok_and_val)
      tok, val = tok_and_val
      tag = TOKEN_TO_TAG[tok]


      if tag == :cocomment
        handle_comment(val)
      else
        len = val.gsub(RougeCode::LITERAL_PROXY, '').length
        @line_len += len
        @tokens << [tag, val] unless val.length.zero?
      end
    end

    CALLOUT_PATTERN = %r{<\s*(label|callout)\s+id=(\'|\")(.*?)\2\s*\/>\s*}

    def handle_comment(val)
      case val
      when /START_HIGHLIGHT/
        @code_block.highlighting = true
        @tokens << [:elided_comment, nil]

      when /END_HIGHLIGHT/
        @code_block.highlighting = false
        @tokens << [:elided_comment, nil]

      when CALLOUT_PATTERN
        unless @code_block.options['add-id'] == "no"
          @has_id = $3
          if $1 == 'callout'
            @callout = $1
          else
            @code_block.number_lines = true
          end
        end

        val = val.sub(CALLOUT_PATTERN, '')
        if val =~ %r{^(\/\*|\/\/|\#|;|%|<!--|--)\s*(\*\/|-->)?$}
          @tokens << [nil, ""]
        else
          @tokens << [:cocomment, val ]
        end

      else
         @tokens << [:cocomment, val]

      end
    end


    def is_elided?
      return false if @tokens.length.zero?

      i = 0
      last = @tokens.size - 1

      while i < last && @tokens[i][0].nil? && @tokens[i][1] =~ /^\s*$/
        i += 1
      end

      i == last && @tokens[i][0] == :elided_comment
    rescue
      STDERR.puts "BOOM!"
      STDERR.puts @tokens.inspect
      false
    end

    def empty?
      @tokens.empty?
    end

    def each
      @tokens.each {|t| yield t}
    end
  end
end
