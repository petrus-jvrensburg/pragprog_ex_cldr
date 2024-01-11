module CodeRay
  module Scanners
  
    class Session < Scanner
    
      include Streamable

      register_for :session
    
      def scan_tokens(tokens, options)
        state = :initial
      
        until eos?
          # STDERR.puts "#{state}: #{pos} #{peek(10).inspect}"
          case state
          
          when :initial
            if match = scan(/\s*#.*_HIGHLIGHT.*\n?/)
              tokens << [ match, :comment]
            elsif match = scan(%r{ ^\s*( [-\w@:~\s]*\$\s
                                 | \w+\[.*?\]
                                 | [-\w~/\\\\:.]+[>$#]
                                 | >>>?
                                 | \.\.\.
                                 )}x)
          
              tokens << [ match, :prompt ]
              state = :prompt_seen
            else
              line = scan(/.*\n?/)
              if line =~ /(.*)(#.*)/
                tokens << [ $1, :output ]
                tokens << [ $2, :comment ]
                tokens << [ "\n", :space ]
              else
                tokens << [ line, :output ]
              end
            end
          
          when :prompt_seen, :continuation
            match = scan(/.*\n?/)
            if match =~ /(.*?)(#.*)/
              tokens << [ $1, :user_input ]
              tokens << [ $2, :comment ]
              tokens << [ "\n", :space ]
              state = :initial
            else
              tokens << [ match, :user_input ]
              if match =~ /\\$/
                state = :continuation
			  elsif match = scan(%r{ ^\s*( '''
								 | """
                                 )}x)
				 state = :continuation			 
              else
                state = :initial
              end
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
