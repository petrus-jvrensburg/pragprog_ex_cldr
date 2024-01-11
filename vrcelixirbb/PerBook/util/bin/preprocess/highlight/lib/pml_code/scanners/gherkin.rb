# encoding: utf-8

# For Cucumber scripts

module CodeRay
  module Scanners
    
    # Simple Scanner for Gherkin (Cucumber).
    # 
    class Gherkin < Scanner
      
      include Streamable

      register_for :gherkin
      file_extension 'feature'
      title 'Gherkin'
      
      def scan_tokens(tokens, options)
        until eos?
          kind = match = nil

          case
            when scan(/\s*(Feature:|Egenskap:|Scenario:|Scenario Outline:|Background:|Bakgrunn:|Examples:|Given |Gitt |When |Når |Then |Så |And |Og |But |Men |\* )/)
            kind = :keyword 

          when scan(/[^@#"\n]+/)
            kind = :output

          when scan(/\n/)
            kind = :output
            
          when scan(/#.*/)
            kind = :comment
            
          when scan(/@.*/)
            kind = :string 

          when scan(/"""/)
            kind =  :keyword

          when scan(/".*?"/)
            kind = :string
          
          when scan(/([^\|]*)(\|\s*)/)
            tokens << [ $1, :output ]
            tokens << [ $2, :keyword ]
            next

          else
            fail "ERROR"
          end
          tokens << [ match || matched, kind]
        end

        tokens
      end
      
    end
    
  end
end
