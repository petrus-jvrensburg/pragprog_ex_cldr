# From pygments compiled.py

module CodeRay
module Scanners

  class Prolog < Scanner

    include Streamable
    
    register_for :prolog, :pl
    file_extension 'pl'

    OPERATORS = %r{(is|<|>|=<|>=|==|=:=|=|/|//|\*|\+|-)(?=\s|[a-zA-Z0-9\[])}


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
            
          when scan(%r{#.*})
            kind = :comment

          when scan(%r{/\*.*?\*/}m)
            kind = :comment

          when scan(%r{[0-9]+})
            kind = :number


          when scan(%r'[\[\](){}|.,;!]')
            kind = :text

          when scan(%r{:-|-->})
            kind = :keyword


          when match = scan(OPERATORS)
            kind = :operator

          when match = scan(%r'(mod|div|not)\b')
            kind = :operator

          when match = scan(%r{"})  #"
            tokens << [:open, :string]
            state = :string
            kind  = :delimiter
            

          when match = scan(%r'([a-z]+)(:)')
            kind = :identifier
            
          when match = scan(%r'([a-z\u00c0-\u1fff\u3040-\ud7ff\ue000-\uffef][a-zA-Z0-9_$\u00c0-\u1fff\u3040-\ud7ff\ue000-\uffef]*)')
            kind = :identifier

          when match = scan(%r'[a-z\u00c0-\u1fff\u3040-\ud7ff\ue000-\uffef][a-zA-Z0-9_$\u00c0-\u1fff\u3040-\ud7ff\ue000-\uffef]*')
            kind = :content  # atom, characters

          when match = scan(%r'[#&*+\-./:<=>?@\^~\u00a1-\u00bf\u2010-\u303f]+')
            kind = :content

          when match = scan(/[A-Z]\w+/)
            kind = :keyword

          else
            getch
            kind = :error

          end
        
          
        when :string
          if scan(%r'"(?:\\x[0-9a-fA-F]+|\\u[0-9a-fA-F]{4}|\\U[0-9a-fA-F]{8}|[0-7]+|[\w\W]|[^"])*"')
            kind = :content
          elsif scan(%r"'(?:''|[^'])*'")
            kind = :scontent  # quoted atom
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
                                                             
