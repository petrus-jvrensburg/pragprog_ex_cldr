# -*- coding: utf-8 -*- #

require "rouge"

module Rouge
  module Lexers
    class Ludwig < RegexLexer
      title "Ludwig"
      desc "The Ludwig programming language (fugue.io)"

      tag 'ludwig'
      aliases 'lw'
      filenames '*.lw'
      mimetypes 'text/x-ludwig'

      reserved = %w(
        _
        case of if then else elif
        language
        import as export
        type fun operator infixr infixl prefix language
        let with
        composition validate
      )

      annotations = %w(language proto mutable)

      state :root do
        rule /\s+/m, Text

        rule /\#.*?$/, Comment
        rule /\d+/, Num::Integer
        rule /\d+\.\d+/, Num::Float
        rule /\"/, Str, :double_quote
        rule /\'/, Str, :single_quote

        rule /\berror\b/, Name::Exception

        rule /\b(?:#{reserved.join('|')})\b/o, Keyword::Reserved
        rule /@(?:#{annotations.join('|')})/o, Name::Decorator

        rule /^([_a-z][-_\w]*)(:)/ do
          groups(Name::Variable, Punctuation)
        end

        rule /[a-z][-_\w]*/, Name
        rule /[A-Z][-_\w.]*\b/, Keyword::Type

        rule /(->|\|)/, Operator
        rule /[-+\/*=%$!&|^<>][-+\/*=%$!&|^<>.]*/, Operator
        rule /[\[\](),;{}<>:.]/, Punctuation
      end

      state :double_quote do
        rule /\"/, Str, :pop!
        rule /[^\\\"]+/, Str
      end

      state :single_quote do
        rule /\'/, Str, :pop!
        rule /[^\\']+/, Str
      end
    end
  end
end


