# encoding: utf-8
module CodeRay
module Scanners

  # This scanner is basically the existing Ruby one, with a sprinkling
  # of CS keywords etc.

  class Coffeescript < Scanner

    include Streamable

    register_for :coffeescript
    file_extension 'coffee'
    
    JAVASCRIPT_KEYWORDS = %w{
      true false null this
      new delete typeof in instanceof
      return throw break continue debugger
      if else switch for while do try catch finally
      class extends super
    }

    # CoffeeScript-only keywords.
    COFFEESCRIPT_KEYWORDS = %w{
      undefined then unless until loop of by when own
    }
    
    IDENT_KIND = CaseIgnoringWordList.new(:ident).
      add(COFFEESCRIPT_KEYWORDS, :reserved).
      add(JAVASCRIPT_KEYWORDS, :reserved)
      
    NUMBER = %r{
       0x[\da-f]+ |                              # hex
       (?: \d+(\.\d+)? | \.\d+ ) (?:e[+-]?\d+)?  # decimal
    }ix
    
    JSTOKEN    = /`[^\\`]*(?:\\.[^\\`]*)*`/m
    
    COMMENT    = /^###([^#][\s\S]*?)(?:###[^\n\S]*|(?:###)?$)|^(?:\s*#(?!##[^#]).*)+/
    
    OPERATOR   = %r{ (?:
         ->
       | =>
       | =
       | &&= | \|\= | >>= | <<\
       | >>=?
       | >>>=?             # zero-fill right shift
       | <<=?
       | [-+*/%<>&|^!?=]=  # compound assign / compare
       | -- | \+\+ | ::
       | \?\.              # soak access
       | \.{2,3}           # range or splat
       
       | \?
       | \( | \)
       | \[ | \]
       
       | ;                 # terminator 
       
       | \* | / | %        # math
       
       | == | != | <=? | >=? # comparison
       
       | ! | ~ | NEW | TYPEOF | DELETE | DO  # unary
       
       | && | \|\| | & | \| | \^   # logic
       
    ) }xi
    
    IDENTIFIER = %r{
      [$@\w_][\w_]* 
    }x
        
  private
    def scan_tokens(tokens, options)
      @tokens = tokens
      @state  = [ :initial ]
      @delimiter = []
      
      until eos?
        case @state.last 
        when :initial, :interpolating
          @tokens << (
            identifier_token             ||
            comment_token                ||
            whitespace_token             ||
            singlequoted_string_token    ||
            doublequoted_string_token    ||
            number_token                 ||
            js_token                     ||
            end_interpolation_token      ||
            literal_token                ||
            error
            )

        when :single_quoted_string 
          case
          when match = scan(/\\.?/)
            @tokens << [ match, :content ]
          when match = scan(/#{@delimiter.last}/)
            @tokens << [ match, :delimiter ]
            @tokens << [ :close, :string ]
            @state.pop       
            @delimiter.pop
          when match = scan(/[^\\']+/)
            @tokens << [ match, :content ]
          else
            @tokens << [ getch, :content ]
          end

        when :double_quoted_string 
          case
          when match = scan(/\\.?/)
            @tokens << [ match, :content ]
          when match = scan(/#{@delimiter.last}/)
            @tokens << [ match, :delimiter ]
            @tokens << [ :close, :string ]
            @state.pop
            @delimiter.pop
          when match = scan(/#\{/)
            @tokens << [ match, :operator ]
            @state.push :interpolating
          when match = scan(/[^\\"\#]+/)
            @tokens << [ match, :content ]
          else
            @tokens << [ getch, :content ]
          end

        else
          raise "Invalid state: #{state}"
        end
        raise("Too many tokens") if @tokens.size > 20000
      end                     
#      @tokens.each do |t|
#        STDERR.puts t.inspect
#      end
      @tokens
    end

    def identifier_token 
      if match = scan(IDENTIFIER)
        [ match, IDENT_KIND[match] ]
      end
    end

    def comment_token
      if match = scan(COMMENT)
        [ match, :comment ]
      end    
    end

    def whitespace_token
      if match = scan(/[\n\s]+/)
        [ match, :space ]
      end
    end

    def singlequoted_string_token
      if match = scan(/'''|'/)
        @state.push :single_quoted_string
        @delimiter.push(match)
        @tokens << [ :open, :string ]
        [ match, :delimiter ]
      end
    end

    def doublequoted_string_token 
      if match = scan(%r{"""|"|///})
        @state.push :double_quoted_string
        @delimiter.push(match)
        @tokens << [ :open, :string ]
        [ match, :delimiter ]
      end
    end

    def number_token     
      if match = scan(NUMBER)
        [ match, :number ]
      end
    end

    def js_token 
      if match = scan(JSTOKEN)
        [ match, :string ]
      end        
    end
    
    def end_interpolation_token
      if @state.last == :interpolating && scan(/\}/)
        @state.pop
        [ "}", :operator ]
      end
    end
    
    def literal_token 
      if match = scan(OPERATOR)
        if match == "->" || match == "=>"
          [ match, :reserved ]
        else
          [ match, :operator ]
        end
      end      
      # else if value in LOGIC or value is '?' and prev?.spaced then tag = 'LOGIC'
      # else if prev and not prev.spaced
      #   if value is '(' and prev[0] in CALLABLE
      #     prev[0] = 'FUNC_EXIST' if prev[0] is '?'
      #     tag = 'CALL_START'
      #   else if value is '[' and prev[0] in INDEXABLE
      #     tag = 'INDEX_START'
      #     switch prev[0]
      #       when '?'  then prev[0] = 'INDEX_SOAK'
      #       when '::' then prev[0] = 'INDEX_PROTO'
      # @token tag, value
      # value.length   
    end
    
    def error
      [ getch, :error ]
    end
  end
  
end
end
