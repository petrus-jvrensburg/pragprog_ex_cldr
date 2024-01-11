module CodeRay
module Scanners

  class Go < Scanner

    include Streamable
    
    register_for :go
    file_extension 'go'

    RESERVED_WORDS = %w{
        break
        case
        continue
        default
        defer
        else
        fallthrough
        for
        go
        goto
        if
        range
        return
        select
        switch
        chan
        const
        func
        import
        interface
        map
        package
        struct
        type
        var
      }


      PREDEFINED_TYPES = %w{
        bool
        byte
        complex64
        complex128
        float32
        float64
        int8
        int16
        int32
        int64
        string
        uint8
        uint16
        uint32
        uint64
        int
        uint
        uintptr
        rune
      }

    PREDEFINED_CONSTANTS = %w{
      false
      iota
      nil
      true
    }

#    DIRECTIVES = [
#      'auto', 'extern', 'register', 'static', 'void',
#      'const', 'volatile',  # added in C89
#      'inline',  # added in C99
#    ]

    IDENT_KIND = WordList.new(:ident).
      add(RESERVED_WORDS, :reserved).
      add(PREDEFINED_TYPES, :pre_type).
 #     add(DIRECTIVES, :directive).
      add(PREDEFINED_CONSTANTS, :pre_constant)

    ESCAPE = / [rbfntv\n\\'"] | x[a-fA-F0-9]{1,2} | [0-7]{1,3} /x
    UNICODE_ESCAPE =  / u[a-fA-F0-9]{4} | U[a-fA-F0-9]{8} /x

    def scan_tokens tokens, options

      state = :initial
      label_expected = true
      case_expected = false

      until eos?

        kind = nil
        match = nil
        
        case state

        when :initial

          if match = scan(/ \s+ | \\\n /x)
            tokens << [match, :space]
            next

          elsif scan(%r! // [^\n\\]* (?: \\. [^\n\\]* )* | /\* (?: .*? \*/ | .* ) !mx)
            kind = :comment

          elsif match = scan(/ [-+*=<>?:;,!&^|()\[\]{}~%]+ | \/=? | \.(?!\d) /x)
            label_expected = match =~ /[;\{\}]/
            if case_expected
              label_expected = true if match == ':'
              case_expected = false
            end
            kind = :operator

          elsif match = scan(/ [A-Za-z_][A-Za-z_0-9]* /x)
            kind = IDENT_KIND[match]
            if kind == :ident && label_expected && scan(/:(?!:)/)
              kind = :label
              match << matched
            else
              label_expected = false
              if kind == :reserved
                case match
                when 'case', 'default'
                  case_expected = true
                end
              end
            end

          elsif match = scan(/"/)
            tokens << [:open, :string]
            state = :dq_string
            kind = :delimiter

          elsif match = scan(/'/)
            tokens << [:open, :string]
            state = :sq_string
            kind = :delimiter

          elsif match = scan(/`/)
            tokens << [:open, :string]
            state = :raw_string
            kind = :delimiter


          elsif scan(/  (?: [^\'\n\\] | \\ #{ESCAPE} )? '? /ox)
            label_expected = false
            kind = :char

          elsif scan(/0[xX][0-9A-Fa-f]+/)
            label_expected = false
            kind = :hex

          elsif scan(/(?:0[0-7]+)(?![89.eEfF])/)
            label_expected = false
            kind = :oct

          elsif scan(/(?:\d+)(?![.eEfF])L?L?/)
            label_expected = false
            kind = :integer

          elsif scan(/\d[fF]?|\d*\.\d+(?:[eE][+-]?\d+)?[fF]?|\d+[eE][+-]?\d+[fF]?/)
            label_expected = false
            kind = :float

          else
            getch
            kind = :error

          end

        when :sq_string
          if scan(/[^\n']+/)
            kind = :content
          elsif scan(/\'/)
            tokens << ["'", :delimiter]
            tokens << [:close, :string]
            state = :initial
            label_expected = false
            next
          else
            raise_inspect "Invalid single quote string: %p not handled." % peek(1), tokens
          end


        when :dq_string
          if scan(/\\./)   # cheap shot, but handles \"
            kind = :content
          elsif scan(/[^\\\n"]+/)
            kind = :content
          elsif scan(/\"/)
            tokens << ['"', :delimiter]
            tokens << [:close, :string]
            state = :initial
            label_expected = false
            next
          else
            raise_inspect "Invalid double quote string: %p not handled." % peek(1), tokens
          end

        when :raw_string
          if scan(/[^`]+/)
            kind = :content
          elsif scan(/\`/)
            tokens << ['`', :delimiter]
            tokens << [:close, :string]
            state = :initial
            label_expected = false
            next
          else
            raise_inspect "Invalid raw string: %p not handled." % peek(1), tokens
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

#      if state == :string
#        tokens << [:close, :string]
#      end

      tokens
    end

  end

end
end
