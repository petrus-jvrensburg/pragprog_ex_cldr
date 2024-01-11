# encoding: utf-8

module Rouge
  module Lexers
    class Repl < RegexLexer
      title "repl"
      desc "The Clojure repl"

      tag 'repl'

      filenames '*.repl'

      def self.analyze_text(text)
        0
      end

      def initialize(opts={})
        @clojure_lexer = Clojure.new(opts)
        super()
      end

      start do
        @clojure_lexer.reset!
      end

      prompt = %r{([A-Za-z][-.:_A-Za-z0-9]+|\s*\#_)=>}

      state :root do
        rule prompt, Generic::Prompt, :clojure
        rule /\s*\#\s*(START|END)_HIGHLIGHT\s*\n?/, Comment
        rule /(?=\(\S)/, Text, :clojure
        rule /[^\n*]\n?/, Text, :clojure
      end

      state :clojure do
        rule /[^\n]*\n?/ do |code|
          delegate @clojure_lexer, code.matched
          pop!
        end
      end
    end
  end
end
