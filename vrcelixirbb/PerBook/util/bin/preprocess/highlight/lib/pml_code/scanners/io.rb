# From pygments agile.py

module CodeRay
module Scanners

  class IO < Scanner

    include Streamable
    
    register_for :io
    file_extension 'io'

    RESERVED_WORDS =  %w{ clone do doFile doString method for if else elseif then}

    PREDEFINED_TYPES = %w{ Object list List Map args Sequence Coroutine File }

    PREDEFINED_CONSTANTS = %w{ false nil true }
    
    OPERATORS = Regexp.new([
         '::=', ':=', '=', '(', ')', ';', ',', '*', '-', '+', '>', '<', '@', '!', '/', '\\', 
         '^', '.', '%', '&', '[', ']', '{', '}' ].map {|o| Regexp.escape(o) }.join("|"))

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
            
          when scan(%r{//.*|#.*})
            kind = :comment

          when scan(%r{/\*.*?\*/}m)
            kind = :comment

          when match = scan(OPERATORS)
            kind = :operator
          
          when match = scan(%r{"})  #"
            tokens << [:open, :string]
            state = :string
            kind  = :delimiter
            
          when match = scan(/ [A-Za-z_][A-Za-z_0-9]* /x)
            kind = IDENT_KIND[match]

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
        
          
        when :string
          if scan(/[^"]+/)
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
                                                             
