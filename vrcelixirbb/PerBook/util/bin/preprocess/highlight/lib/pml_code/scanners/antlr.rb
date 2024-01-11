# encoding: utf-8
module CodeRay
  module Scanners
    
    class Antlr < Scanner
      
      register_for :antlr
      file_extension 'g'
      
      KEYWORDS = %w{ protected public private fragment returns init import header 
 	             parser lexer tree grammar tokens options EOF scope 
		     throws exception catch finally locals}

      IDENT = %{[a-zA-Z_+][a-zA-Z0-9_]*}

      STRING_CONTENT_PATTERN = {
          "'" => /[^\\']+/,
          '"' => /[^\\"]+/,
          '/' => /[^\\\/]+/,
      } 

      def scan_tokens(tokens, options)

        state = :initial
        string_delimiter = nil

        until eos?
          
          kind = nil
          match = nil
          
          case state
            
          when :initial
            
            if match = scan(/ \s+ | \\\n /x)
              tokens << [match, :space]
              next
          
            elsif match = scan(%r! // [^\n\\]* (?: \\. [^\n\\]* )* | /\* (?: .*? \*/ | .* ) !mx)
              tokens << [match, :comment]
              next
          
          
            elsif match = scan(/ #{IDENT} /ox)
              if KEYWORDS.include?(match)
                kind = :keyword
              else
                kind = :ident
              end

            elsif match = scan(/["']/)
              tokens << [:open, :string]
              state = :string
              string_delimiter = match
              kind = :delimiter

            elsif scan(/ @ #{IDENT} /ox)
              kind = :keyword

            else
              getch
              kind = :error
              
            end
            
          when :string
            if scan(STRING_CONTENT_PATTERN[string_delimiter])
              kind = :content
            elsif match = scan(/["'\/]/)
              tokens << [match, :delimiter]
              tokens << [:close, state]
              string_delimiter = nil
              state = :initial
              next
            elsif scan(/\\./m)
              kind = :content
            elsif scan(/ \\ | $ /x)
              tokens << [:close, state]
              kind = :error
              state = :initial
            end

          else
            raise_inspect 'Unknown state', tokens
            
          end
          
        match ||= matched

        raise_inspect 'Empty token', tokens unless match
        
          tokens << [match, kind]
          
        end
        
        if state == :string
          tokens << [:close, state]
        end
        
        tokens 
      end

    end
  end
end
