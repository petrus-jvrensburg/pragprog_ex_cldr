module CodeRay
  module Scanners

    # Like session, but
    #  -> indicates output and
    #  user=> is a prompt

    class Repl < Scanner

      include Streamable

      register_for :repl

      def scan_tokens(tokens, options)
        state = :initial

        until eos?
          # STDERR.puts "#{state}: #{pos} #{peek(10).inspect}"
          case state

          when :initial
            if match = scan(/%r{;.*\n}/)
              tokens << [ match, :comment ]

            elsif match = scan(%r{([A-Za-z][-._A-Za-z0-9]+|\s*#_)=>})
              tokens << [ match, :prompt ]
              state = :prompt_seen
            else
              match = scan(/.*\n?/)
              if match =~ /(.*?)(;.*\n?)/
                tokens << [ $1, :output ]
                tokens << [ $2, :comment ]
              else
                tokens << [ match, :output ]
              end
            end

          when :prompt_seen, :continuation
            match = scan(/.*\n?/)
            if match =~ /(.*?)(;.*\n?)/
              tokens << [ $1, :user_input ]
              tokens << [ $2, :comment ]
              state = :initial
            else
              tokens << [ match, :user_input ]
              if match =~ /\\$/
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
