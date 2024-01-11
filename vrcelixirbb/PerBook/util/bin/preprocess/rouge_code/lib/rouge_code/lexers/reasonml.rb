# -*- coding: utf-8 -*- #
# frozen_string_literal: true
# This was made by the author of the ReasnML book. It is
# based on the Rust lexer.
module Rouge
  module Lexers
    class Reasonml < RegexLexer
      title "Reason"
      desc 'The ReasonML programming language (reasonml.github.io/)'
      tag 'reason'
      aliases 're', 'rei'
      filenames '*.re', '*.rei'
      mimetypes 'text/x-reasonml'

      def self.detect?(text)
        return true if text.shebang? 'rustc'
      end

      def self.keywords
        @keywords ||= %w(
          and as assert begin class constraint done downto exception external fun
          esfun function functor include inherit initializer lazy let pub mutable new nonrec
          object of open or pri rec then to type val virtual
          try catch finally do else for if switch while import library export
          module in raise
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
          float int int32 int64 long string array list ref true false unit
        )
      end

#      delim_map = { '[' => ']', '(' => ')', '{' => '}' }

      id = /[a-z_]\w*/i
      hex = /[0-9a-f]/i
      escapes = %r(
        \\ ([nrt'\\] | x#{hex}{2} | u#{hex}{4} | U#{hex}{8})
      )x
      size = /8|16|32|64/

      state :start_line do
        mixin :whitespace
        rule /\s+/, Text
        rule /#\[/ do
          token Name::Decorator; push :attribute
        end
        rule(//) { pop! }
        rule /#\s[^\n]*/, Comment::Preproc
      end

      state :attribute do
        mixin :whitespace
        mixin :has_literals
        rule /[(,)=]/, Name::Decorator
        rule /\]/, Name::Decorator, :pop!
        rule id, Name::Decorator
      end

      state :whitespace do
        rule /\s+/, Text
        rule %r(//[^\n]*), Comment
        rule %r(/[*].*?[*]/)m, Comment::Multiline
      end

      state :root do
        rule /\n/, Text, :start_line
        mixin :whitespace
        rule /\b(?:#{Rust.keywords.join('|')})\b/, Keyword
        mixin :has_literals

        rule %r([=-]>), Keyword
        rule %r(<->), Keyword
        rule /[()\[\]{}|,:;]/, Punctuation
        rule /[*!@~&+%^<>=-\?]|\.{2,3}/, Operator

        rule /([.]\s*)?#{id}(?=\s*[(])/m, Name::Function
        rule /[.]\s*#{id}/, Name::Property
        rule /(#{id})(::)/m do
          groups Name::Namespace, Punctuation
        end
      end

      state :has_literals do
        # constants
        rule /\b(?:true|false|nil)\b/, Keyword::Constant
        # characters
        rule %r(
          ' (?: #{escapes} | [^\\] ) '
        )x, Str::Char

        rule /"/, Str, :string

        rule /\{js?\|/, Str, :jString

        # numbers
        dot = /[.][0-9_]+/
        exp = /e[-+]?[0-9_]+/
        flt = /f32|f64/

        rule %r(
          [0-9]+
          (#{dot}  #{exp}? #{flt}?
          |#{dot}? #{exp}  #{flt}?
          |#{dot}? #{exp}? #{flt}
          )
        )x, Num::Float

        rule %r(
          ( 0[bB][10_]+
          | 0[xX][0-9a-fA-F-]+
          | 0[oO][0-7_]+
          | [0-9]+
          ) ([Lln])?
        )x, Num::Integer

      end

      state :string do
        rule /"/, Str, :pop!
        rule escapes, Str::Escape
        rule /[^"\\]+/m, Str
      end

      state :jString do
        rule /\|js?\}/, Str, :pop!
        rule escapes, Str::Escape
#        rule /\$/, Str::Interpol, :varInString
#        rule %r(
#          \$([a-z]\w+) # variable name
#        )x, Str::Interpol
        rule /[^\\\|]+/m, Str
      end

#      state :varInString do
#        rule /[^\W]+/m, Str::Interpol
#        rule /\W/, Str
#      end
    end
  end
end
