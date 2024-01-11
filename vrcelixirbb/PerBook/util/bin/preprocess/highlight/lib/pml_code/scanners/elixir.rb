module CodeRay
module Scanners

  class Elixir < Scanner

    include Streamable
    
    register_for :elixir, :ex, :exs, :iex
    file_extension 'ex'

    RESERVED_WORDS = 
      %w{
       __FILE__
       __LINE__
       __MAIN__
       __MODULE__
       after
       and
       bc
       case
       catch
       cond
       defdelegate
       defexception
       defimpl
       defmacro
       defmacrop
       defmodule
       def
       defp
       defprotocol
       defstruct
       do
       else
       end
       exit
       false
       fn
       for
       if
       import
       in
       lc
       nil
       not
       or
       quote
       raise
       receive
       recur
       refer
       require
       rescue
       super
       throw
       true
       try
       unless
       unless
       unquote
       use
       when
       xor
      __FUNCTION__
       }

    PREDEFINED_FUNCTIONS = [
    ]

    OPERATORS = Regexp.new(%w{
            -> %= *=  **= += -= ^= ||= 
            <=> <= >= === == =~ != !~ ?
            + && || ^ * +| - / \'
            | ++ -- ** // <- -> <> << >> = .
       }.map {|o| Regexp.escape(o) }.join("|"))


    IDENT_KIND = WordList.new(:ident).
      add(RESERVED_WORDS, :reserved).
      add(PREDEFINED_FUNCTIONS, :pre_type)

    SYMBOL_RE = %r{
     :(
        [a-zA-Z_][\w@]*[?!]? |
        =(?![>=])?        |
        \<\>              |
        ===?              |
        >=?               |
        <=?               |
        <=>               |
        &&?               |
        %\(\)             |
        %\[\]             |
        %\{\}             |
        \+\+?             |
        \-\-?             |
        \|\|?             |
        \!                |
        //                |
       [%&`/\|]           |
       \*\*?              |
       =?~                |
       <\-
      )                   |
      ([a-zA-Z_]\w*([?!])?)(:)(?!:)}x # `


    VARIABLE_RE = %r{(?:[a-zA-Z0-9]\w+(!|\?)?)}



    def scan_tokens tokens, options

      state = :initial
      end_of_string = nil

      until eos?

        kind = nil
        match = nil

        case state

        when :initial
    
          case

          when scan(%r{\$\s+(?=iex)})
            kind = :comment

          when scan(%r{\s* (iex(\([^>]+\)_?)? | \.\.\.) (\(\d+\))?>}x)
            kind = :comment

          when scan(/@\w+/)
            kind = :reserved

          when match = scan(/ \s+ | \\\n /x)
            tokens << [match, :space]
            next
            
          when scan(%r{#.*})
            kind = :comment

          when match = scan(%r{"""|'''}) #"
            tokens << [:open, :string]
            state = :heredoc
            kind  = :delimiter
            
          when match = scan(%r{"}) #"
            tokens << [:open, :string]
            state = :string
            kind  = :delimiter
            end_of_string = /"/

          when match = scan(%r{'}) #"
            tokens << [:open, :string]
            state = :string
            kind  = :delimiter
            end_of_string = /'/
            
          when match = scan(OPERATORS)
            kind = :operator

          when match = scan(VARIABLE_RE)
            kind = IDENT_KIND[match]
            if kind == :reserved
              case match
              when 'case', 'default'
                case_expected = true
              end
            end


          when match = scan(SYMBOL_RE)
            kind = :identifier

          # when match = scan(MACRO_RE)
          #   kind = :identifier


          # when match = scan(%r{\$(?:#{ESCAPE_RE}|\\[ %]|[^\\])}o)
          #   kind = :identifier

          when match = scan(%r{[+-]?(?:[2-9]|[12][0-9]|3[0-6])\#[0-9a-zA-Z]+})
            kind = :number

          when match = scan(/[+-]?\d+/)
            kind = :number

          when match = scan(/[+-]?\d+\.\d+/)
            kind = :number
            
          when scan(%r{(0[0-7]*|0[xX][\da-fA-F]+|\d+)[lL]?}) 
            kind = :number
            
            
          when scan(%r{(\d+\.\d*|\.\d+)([eE][-+](\d+)?)?[fFdD]?})
            kind = :number
            
          when scan(%r{\+[eE][-+](\d+)?[fFdD]?})
            kind = :number
            
          when scan(%r{\d+([eE][-+](\d+)?)?[fFdD]?})
            kind = :number

          when match = scan(/[\[:_@\".{}()|;,\[\]]/)
            kind = :text
          else
            getch
            kind = :error

          end
        
        when :string
          case
          when scan(/[^\\'"]+/m)
            kind = :content
          when scan(/\\./)
            kind = :content
          when match = scan(end_of_string)
            tokens << [match, :delimiter]
            tokens << [:close, :string]
            state = :initial
            label_expected = false
            next
          when scan(/['"]/)
            kind = :content
          else
            raise_inspect "else case #{end_of_string.inspect} reached; %p not handled." % peek(1), tokens
          end


        when :heredoc
          case
          when match = scan(/"""|'''/)
            tokens << [match, :delimiter]
            tokens << [:close, :string]
            state = :initial
            label_expected = false
            next
          when scan(/[^"]+/)
            kind = :content
          when scan(/""?/)
            kind = :content
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
