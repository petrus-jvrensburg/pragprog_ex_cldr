module CodeRay
module Scanners

  class Scala < Scanner

    include Streamable

    register_for :scala
    file_extension 'scala'

    RESERVED_WORDS = [
      'abstract',
      'case',
      'catch',
      'class',
      'def',
      'default',
      'do',
      'else',
      'extends',
      'final',
      'finally',
      'for',
      'forSome',
      'if',
      'implicit',
      'import',
      'lazy',
      'match',
      'new',
      'object',
      'override',
      'package',
      'private',
      'protected',
      'requires',
      'return',
      'sealed',
      'super',
      'this',
      'throw',
      'trait',
      'try',
      'type',
      'val',
      'var',
      'while',
      'with',
      'yield'

    ]

    PREDEFINED_TYPES = [
      'Any',
      'AnyRef',
      'AnyVal',
      'Array',
      'Boolean',
      'Int',
      'Integer',
      'List',
      'Nothing',
      'Null',
      'Option',
      'String',
      'Unit',
      'boolean',
      'int',
      'unit'
    ]

    PREDEFINED_CONSTANTS = [
      'false', 'null', 'true'
    ]

    OPERATORS = Regexp.new([
      ':', '*', '&', '%', '!', ';', '<', '>', '?', '_', '=', '=>',
     '<-', '<:', '<%', '>:', '#', '@'
    ].map {|o| Regexp.escape(o) }.join("|"))

    IDENT_KIND = WordList.new(:ident).
      add(RESERVED_WORDS, :reserved).
      add(PREDEFINED_TYPES, :pre_type).
      add(PREDEFINED_CONSTANTS, :pre_constant)

    ESCAPE = / [rbfntv\n\\'"] | x[a-fA-F0-9]{1,2} | [0-7]{1,3} /x
    UNICODE_ESCAPE =  / u[a-fA-F0-9]{4} | U[a-fA-F0-9]{8} /x

    def scan_tokens tokens, options

      state = :initial

      until eos?

        kind = nil
        match = nil

        case state

        when :initial

          case
          when match = scan(/ \s+ | \\\n /x)
            tokens << [match, :space]
            next

          when scan(%r! // [^\n\\]* (?: \\. [^\n\\]* )* | /\* (?: .*? \*/ | .* ) !mx)
            kind = :comment

          when match = scan(OPERATORS)
            kind = :operator

          when match = scan(%r{"""})
            tokens << [:open, :string]
            state = :multi_line_string
            kind  = :delimiter

          when match = scan(%r{"})
            tokens << [:open, :string]
            state = :string
            kind  = :delimiter

          when match = scan(/ [A-Za-z_][A-Za-z_0-9]* /x)
            kind = IDENT_KIND[match]
            if kind == :reserved
              case match
              when 'case', 'default'
                case_expected = true
              end
            end

          when scan(%r{(0[0-7]*|0[xX][\da-fA-F]+|\d+)[lL]?})
            kind = :number


          when scan(%r{(\d+\.\d*|\.\d+)([eE][-+](\d+)?)?[fFdD]?})
            kind = :number

          when scan(%r{\+[eE][-+](\d+)?[fFdD]?})
            kind = :number

          when scan(%r{\d+([eE][-+](\d+)?)?[fFdD]?})
            kind = :number

          else
            getch
            kind = :error

          end

        when :multi_line_string
          if match = scan(/.*?"""/m)
            content = match[0...-3]
            tokens << [content,     :content]
            tokens << ['"""',  :delimiter]
            tokens << [:close, :string]
            state = :initial
            next
          else
            raise_inspect("Unterminated multi-line string")
          end

        when :string
          if scan(/[^\\\n"]+/)
            kind = :content
          elsif scan(/\\./)
            kind = :content
          elsif scan(/"/)
            tokens << ['"', :delimiter]
            tokens << [:close, :string]
            state = :initial
            label_expected = false
            next
          else
            raise_inspect "else case \" reached; %p not handled." % peek(1), tokens
          end

        else
          raise_inspect 'Unknown state', tokens

        end

        match ||= matched
        if $CODERAY_DEBUG and not kind
          raise_inspect 'Error token %p in line %d' %
            [[match, kind], line], tokens
        end
        raise_inspect 'Empty token', tokens unless match

        tokens << [match, kind]

      end

      if state == :string
        tokens << [:close, :string]
      end

      tokens
    end

  end

end
end
