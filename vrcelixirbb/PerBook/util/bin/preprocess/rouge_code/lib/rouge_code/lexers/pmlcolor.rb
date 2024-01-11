# -*- coding: utf-8 -*- #

module Rouge
  module Lexers

    class Pmlcolor < RegexLexer
      title "PML Color Sessions"
      desc "For use in Cucumber and other places were session need special highlighting"

      tag 'pmlcolor'
      filenames '*.pmlcolor'
      mimetypes 'text/session'

      def self.analyze_text(text)
        0
      end



      state :root do

        rule %r{\s*\#.*?\n}, Comment


        rule %r{.*?\n}, Generic::Output

      end

    end
  end
end
