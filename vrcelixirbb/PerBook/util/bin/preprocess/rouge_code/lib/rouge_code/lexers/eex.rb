# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class EEX < TemplateLexer
      title "EEX"
      desc "Embedded Elixir template files"

      tag 'eex'

      filenames '*.eex'

      def self.analyze_text(text)
        return 0.2 if text =~ /<%.*%>/
      end

      def initialize(opts={})
        @elixir_lexer = Elixir.new(opts)

        super(opts)
      end

      start do
        parent.reset!
        @elixir_lexer.reset!
      end

      open  = /<%%|<%=|<%#|<%-|<%/
      close = /%%>|-%>|%>/

      state :root do
        rule /<%\#/, Comment, :comment

        rule open, Comment::Preproc, :elixir

        rule /.+?(?=#{open})|.+/m do
          delegate parent
        end
      end

      state :comment do
        rule close, Comment, :pop!
        rule /.+(?=#{close})|.+/m, Comment
      end

      state :elixir do
        rule close, Comment::Preproc, :pop!

        rule /.+?(?=#{close})|.+/m do
          delegate @elixir_lexer
        end
      end
    end
  end
end
