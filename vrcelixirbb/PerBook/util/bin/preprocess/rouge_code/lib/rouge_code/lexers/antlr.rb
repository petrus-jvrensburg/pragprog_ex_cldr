# -*- coding: utf-8 -*- #

module Rouge
  module Lexers

    class Antlr < RegexLexer
      title "Antlr"
      desc "Antlr parser generator language"

      tag 'antlr'
      aliases 'g4'

      filenames '*.g4', '*.g', '*.antlr'

      mimetypes 'text/x-antlr', 'application/x-antlr'

      BRACES = [] unless  defined?(BRACES)
      BRACES.replace [
        ['\{', '\}', 'cb'],
        ['\[', '\]', 'sb'],
        ['\(', '\)', 'pa'],
        ['\<', '\>', 'lt']
      ]

      state :root do
        rule /\s+/m, Text
        rule %r{//.*},       Comment::Single
        rule %r(/\*.*?\*/)m, Comment::Multiline
        rule %r{\b(
            EOF
            | catch
            | exception
            | finally
            | fragment
            | grammar
            | header
            | import
            | init
            | lexer
            | locals
            | options
            | parser
            | private
            | protected
            | public
            | returns
            | scope
            | throws
            | tokens
            | tree
        )\b}x, Keyword

        rule /[0-9][0-9]*\.[0-9]+([eE][0-9]+)?[fd]?/, Num::Float
        rule /0x[0-9a-fA-F]+/, Num::Hex
        rule /[0-9]+/, Num::Integer

        rule /"(\\\\|\\"|[^"])*"/, Str::Double
        rule /'(\\\\|\\'|[^'])*'/, Str::Single

        rule /@[a-zA-Z_][a-zA-Z0-9_]*/, Keyword
        rule /[a-zA-Z_][a-zA-Z0-9_]*/, Name:Other

      end
    end
  end
end

