# From Pygments

module CodeRay
module Scanners

  class Elm < Scanner

    include Streamable
    
    register_for :elm
    file_extension 'elm'

    RESERVED_WORDS = [
      'case','class','data','default','deriving','do','else', 'error',
      'if','import', 'in','infixl', 'infixr', 'infix','instance',
      'let','module', 'newtype','of','then','type','where','_']


    IDENT_KIND = WordList.new(:ident).
      add(RESERVED_WORDS, :reserved)



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
            
          when scan(%r{--.*?$})
            kind = :comment

          when scan(/\{-.*?-\}/m)
            kind = :comment

          when match = scan(/-\[a-z]+/)
            kind = :keyword

          when match = scan(%r{\"})
            tokens << [:open, :string]
            state = :string
            kind  = :delimiter
            
          when match = scan(/[a-z_][\'\w]+/)
            kind = IDENT_KIND[match]

          when match = scan(/[A-Z][\'\w]+/)
            kind = :keyword

          when match = scan(%r{\\(?![:!\#$%&*+.\\/<=>?@^|~-]+)}) # lambda operator
            kind = :operator

          when match = scan(%r{(<-|::|->|=>|=)(?![:!\#$%&*+.\\/<=>?@^|~-]+)}) # specials
            kind = :operator

          when match = scan(%r{:[:!\#$%&*+.\/<=>?@^|~-]*}) # Constructor operators
            kind = :operator

          when match = scan(%r{[:!\#$%&*+.\\/<=>?@^|~-]+}) # Other operators
            kind = :operator


          when match = scan(%r{\d+[eE][+-]?\d+}) 
            kind = :number

          when match = scan(%r{\d+\.\d+([eE][+-]?\d+)?})
            kind = :number

          when match = scan(%r{0[oO][0-7]+})
            kind = :number

          when match = scan(%r{0[xX][\da-fA-F]+})
            kind = :number

          when match = scan(/\d+/)
            kind = :number

            

          else
            getch
            kind = :error

          end
        
        when :string
          if scan(/[^\\\n"]+/)
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
        #STDERR.puts [match, kind].inspect
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

=begin

    ascii = ['NUL','SOH','[SE]TX','EOT','ENQ','ACK',
             'BEL','BS','HT','LF','VT','FF','CR','S[OI]','DLE',
             'DC[1-4]','NAK','SYN','ETB','CAN',
             'EM','SUB','ESC','[FGRU]S','SP','DEL']

            #  Numbers
            #  Character/String Literals
            (r"'", String.Char, 'character'),
            (r'"', String, 'string'),
            #  Special
            (r'\[\]', Keyword.Type),
            (r'\(\)', Name.Builtin),
            (r'[][(),;`{}]', Punctuation),
        ],
        'import': [
            # Import statements
            (r'\s+', Text),
            (r'"', String, 'string'),
            # after "funclist" state
            (r'\)', Punctuation, '#pop'),
            (r'qualified\b', Keyword),
            # import X as Y
            (r'([A-Z][a-zA-Z0-9_.]*)(\s+)(as)(\s+)([A-Z][a-zA-Z0-9_.]*)',
             bygroups(Name.Namespace, Text, Keyword, Text, Name), '#pop'),
            # import X hiding (functions)
            (r'([A-Z][a-zA-Z0-9_.]*)(\s+)(hiding)(\s+)(\()',
             bygroups(Name.Namespace, Text, Keyword, Text, Punctuation), 'funclist'),
            # import X (functions)
            (r'([A-Z][a-zA-Z0-9_.]*)(\s+)(\()',
             bygroups(Name.Namespace, Text, Punctuation), 'funclist'),
            # import X
            (r'[a-zA-Z0-9_.]+', Name.Namespace, '#pop'),
        ],
        'module': [
            (r'\s+', Text),
            (r'([A-Z][a-zA-Z0-9_.]*)(\s+)(\()',
             bygroups(Name.Namespace, Text, Punctuation), 'funclist'),
            (r'[A-Z][a-zA-Z0-9_.]*', Name.Namespace, '#pop'),
        ],
        'funclist': [
            (r'\s+', Text),
            (r'[A-Z][a-zA-Z0-9_]*', Keyword.Type),
            (r'(_[\w\']+|[a-z][\w\']*)', Name.Function),
            (r'--.*$', Comment.Single),
            (r'{-', Comment.Multiline, 'comment'),
            (r',', Punctuation),
            (r'[:!#$%&*+.\\/<=>?@^|~-]+', Operator),
            # (HACK, but it makes sense to push two instances, believe me)
            (r'\(', Punctuation, ('funclist', 'funclist')),
            (r'\)', Punctuation, '#pop:2'),
        ],
        'comment': [
            # Multiline Comments
            (r'[^-{}]+', Comment.Multiline),
            (r'{-', Comment.Multiline, '#push'),
            (r'-}', Comment.Multiline, '#pop'),
            (r'[-{}]', Comment.Multiline),
        ],
        'character': [
            # Allows multi-chars, incorrectly.
            (r"[^\\']", String.Char),
            (r"\\", String.Escape, 'escape'),
            ("'", String.Char, '#pop'),
        ],
        'string': [
            (r'[^\\"]+', String),
            (r"\\", String.Escape, 'escape'),
            ('"', String, '#pop'),
        ],
        'escape': [
            (r'[abfnrtv"\'&\\]', String.Escape, '#pop'),
            (r'\^[][A-Z@\^_]', String.Escape, '#pop'),
            ('|'.join(ascii), String.Escape, '#pop'),
            (r'o[0-7]+', String.Escape, '#pop'),
            (r'x[\da-fA-F]+', String.Escape, '#pop'),
            (r'\d+', String.Escape, '#pop'),
            (r'\s+\\', String.Escape, '#pop'),
        ],
    }
        
=end
