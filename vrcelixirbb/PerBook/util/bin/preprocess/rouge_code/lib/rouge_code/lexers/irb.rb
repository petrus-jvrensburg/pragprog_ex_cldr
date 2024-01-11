# encoding: utf-8

module Rouge
  module Lexers
    class Irb < RegexLexer
      title "irb"
      desc "Interactive Ruby session"

      tag 'irb'

      filenames '*.irb', '*.irbr'

      def self.analyze_text(text)
        return 0.8 if text =~ /^irb(\(\d+\))?>/
      end

      def initialize(opts={})
        @ruby_lexer = Ruby.new(opts)
        super()
      end

      start do
        @ruby_lexer.reset!
      end

      # should handle
      # simple:
      #  >> require 'rspec/mocks/standalone'
      #  => true
      #
      #  program name
      #  irb(main):001:0> sup
      #  irb(main):002:0> def foo
      #
      #  RVM prompts
      #  jruby-1.7.16 :001 > "RVM-Format"
      prompt = /(^\s*=>|[>?]>|[\w#]+\(\w+\):\d+:\d+>|(\w+-)?\d+\.\d+\.\d(p\d+)?[^>]+>)/

      state :root do
        rule prompt, Generic::Prompt, :ruby
        rule /\s*\#\s*(START|END)_HIGHLIGHT\s*\n?/, Comment
        rule /[^\n*]\n?/, Generic::Output
      end

      state :ruby do
        rule /[^\n]*\n?/ do |code|
          delegate @ruby_lexer, code.matched
          pop!
        end
      end
    end
  end
end
