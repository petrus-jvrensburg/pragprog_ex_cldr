module CodeRay
  module Scanners
  
    class Shell < Scanner
    
      include Streamable

      register_for :shell, :sh
      
    
      RESERVED_WORDS = %w{
        break case cd cp continue do done echo elif else esac eval 
        exec exit export fi for if in mkdir rm read readonly set 
        shift source then trap umask  until wait while
      }
      
      IDENT_KIND = CaseIgnoringWordList.new(:ident).
        add(RESERVED_WORDS, :reserved)
                            
      def scan_tokens(tokens, options)
        state = :initial
        string_end = nil
        string_content = nil
        
        until eos?
          
          kind = match = nil
          
          #  puts "#{state}: #{pos} #{peek(10).inspect}"
          case state
          when :initial
            case 
            when match = scan(/ \s+ | \\\n /x) 
              kind = :space
              
            when match = scan(/#.*/)
              kind = :comment
              
            when match = scan(/\$[A-Za-a0-9_]+/)
              kind = :variable

            when match = scan(/["']/)
              string_end = match
              string_content = []
              tokens << [:open, :string]
              kind = :delimiter
              state = :string
                       
            when match = scan(/[|&;()<>]/)
              kind = :metacharacter
              
            when match = scan(/\|\| | &&? | ;;? | \( | \) | \|/x)
              kind = :control_operator
               
            else
              match = scan(/[^#\s"'|&;()<>]+/)
              if match =~ /^[A-Za-z_]+$/
                kind = IDENT_KIND[match]
              else
                kind = :other
              end
            end

            tokens << [ match, kind ]
            
          when :string
            case
            when match = scan(/[^\\#{string_end}]+/)
              string_content << match
            when match = scan(/\\./m)
              string_content << match
            when match = scan(/#{string_end}/)
              tokens << [ string_content.join, :content ]
              tokens << [ match, :delimiter ]
              tokens << [ :close, :string ]
              state = :initial
            else
              fail "Unmatched in string"
            end
            
          else
            fail "Invalid state #{state}"
          end
        end
        tokens
      end
    end    
  end
end