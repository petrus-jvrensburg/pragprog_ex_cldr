# encoding: utf-8

module Rouge
  module Lexers
    class Iex < RegexLexer
      title "iex"
      desc "Interactive elixir session"

      tag 'iex'

      filenames '*.iex'

      def self.analyze_text(text)
        return 0.8 if text =~ /^iex(\(\d+\))?>/
      end

      def initialize(opts={})
        @elixir_lexer = Elixir.new(opts)
        super()
      end

      start do
        @elixir_lexer.reset!
      end

      prompt = /(\.\.\.|iex)(\(\d+\))?>/

      state :root do
        rule prompt, Generic::Prompt, :elixir
        rule /\s*\#\s*(START|END)_HIGHLIGHT\s*\n?/, Comment
        rule /[^\n*]\n?/, Generic::Output
      end

      state :elixir do
        rule /[^\n]*\n?/ do |code|
          delegate @elixir_lexer, code.matched
          pop!
        end
      end
    end
  end
end
