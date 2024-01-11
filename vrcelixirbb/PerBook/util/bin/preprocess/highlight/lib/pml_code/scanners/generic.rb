module CodeRay
  module Scanners

    # Support simple strings and # for comments
    #  -> indicates output and
    #  user=> is a prompt

    class Generic < Scanner

      include Streamable
      
      register_for :generic

      def scan_tokens tokens, options
       state = :initial
        label_expected = true
        case_expected = false

        until eos?
          if match = scan(/(.*?)(#.*\n?)/)
            match =~ /(.*?)(#.*\n?)/
            tokens << [ $1, :generic ]
            tokens << [ $2, :comment ]
          else
            tokens << [ scan(/.*\n?/), :generic ]
          end
        end
        tokens
      end
    end
  end
end
