# -*- coding: utf-8 -*- #

module Rouge
  module Lexers

    class Session < RegexLexer
      title "Interactive Sessions"
      desc "User sessions with a shell"

      tag 'session'
      filenames '*.session'
      mimetypes 'text/session'

      def self.analyze_text(text)
        0
      end


      PROMPT_RE = %r{ ^\s*
                      ( [-\w@:~\S]*\$\s
                      | [-\w@:\S]*[\$#]\s
                      | \w+\[.*?\]
                      | [-\w~/\\\\:.]+[>$#]
                      | >>>?
                      | >>?
                      | \.\.\.(?!\.)
                      )}x


      state :root do

        rule %r{\s*\#.*?\n}, Comment

        rule PROMPT_RE, Generic::Prompt, :prompt_seen

        rule %r{([^\n\#]+)(\#.*?\n)} do
          groups Generic::Output, Comment
        end

        rule %r{.*?\n}, Generic::Output

      end

      state :prompt_seen do

        rule %r{#.*?\n}, Comment, :pop!
        rule /\n/, Text, :pop!

        rule /\"/, Str, :dq
        rule /\'.*?\'/, Str
        rule /\\./m, Generic::Inserted
        rule /[^ \\ \" \' \n ]+/x, Generic::Inserted
      end

      state :dq do
        rule /\"/, Str, :pop!
        rule /\\./m, Str
        rule /[^\\\"]+/m, Str
      end

    end
  end
end
