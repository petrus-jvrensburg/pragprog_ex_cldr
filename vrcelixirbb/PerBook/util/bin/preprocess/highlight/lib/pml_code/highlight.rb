# encoding: utf-8

require 'rubygems' if RUBY_VERSION < '1.9'
require 'coderay'

require_relative 'highlight/line'
require_relative 'highlight/writer'

require_relative 'scanners/antlr'
require_relative 'scanners/applescript-sebastian'
require_relative 'scanners/clojure'
require_relative 'scanners/coffeescript'
require_relative 'scanners/csharp'
require_relative 'scanners/dart'
require_relative 'scanners/erlang'
require_relative 'scanners/elixir'
require_relative 'scanners/elm'
require_relative 'scanners/generic'
require_relative 'scanners/gherkin'
require_relative 'scanners/go'
require_relative 'scanners/haskell'
require_relative 'scanners/io'
require_relative 'scanners/java_script'
require_relative 'scanners/lua'
require_relative 'scanners/mustache'
require_relative 'scanners/objc'
require_relative 'scanners/opencl'
require_relative 'scanners/perl'
require_relative 'scanners/prolog'
require_relative 'scanners/repl'
require_relative 'scanners/scala'
require_relative 'scanners/session'
require_relative 'scanners/shell'
require_relative 'scanners/swift'
require_relative 'scanners/vim'



module CodeRay
  module Scanners
    map :builder => :ruby
    map :clj     => :clojure
    map :coffee  => :coffeescript
    map :cs      => :csharp
    map :erb     => :rhtml
    map :feature => :gherkin
    map :g       => :antlr
    map :g4      => :antlr
    map :haml    => :plain
    map :m       => :objc
    map :out     => :plain
    map :rb      => :ruby
    map :repl    => :repl
    map :rjs     => :ruby
    map :ru      => :ruby
    map :sass    => :plain
    map :scss    => :css
    map :scpt    => :applescript
    map :txt     => :plain
  end
end


class PmlCode
  class Highlight

    attr_reader :options

    def initialize(source, language, options={}, preprocessor=nil)
      language = language ? language.intern : nil
      @preprocessor = preprocessor

      # I don't want to mess with coderay internals, so
      # this seems to be the best way to detect an unsupported language
      scanner = CodeRay::Scanners.load(language)
      if language && language != :plain && language != :text && language != :txt && scanner.name == "CodeRay::Scanners::Plaintext"
        STDERR.puts "Unsupported language for syntax highlighting: #{language.inspect}"
#        STDERR.puts CodeRay::Scanners.plugin_hash.inspect
#        CodeRay::Scanners.plugin_hash.each do |k, v|
#          STDERR.puts "#{k.inspect} => #{v.inspect}"
#        end
      end

      @options = options

      source.sub!(/\a(\s*\n)+/, '')
      source.sub!(/[\s\n]+\z/, '')

      raise "Empty source" if source.empty?

      @tokens = CodeRay.scan(source, language)
      @lines = normalize(@tokens)
    end

    def to_pml
      Writer.new(@lines, @options, @preprocessor).to_pml
    end

    private


    def normalize(tokens)
#      tokens = set_content_to_literal_type(tokens)
      tokens = split_tokens_containing_newlines(tokens)
      lines  = divide_into_lines(tokens)
      bring_to_margin(lines)
      lines
    end

    def split_tokens_containing_newlines(tokens)
      res = []
      tokens.each do |text, kind|
        if text.kind_of?(String)
          res.concat(text.split(/(\n)/).map {|part| [ part, kind ]})
        else
          res << [ text, kind ]
        end
      end
      res
    end

    def set_content_to_literal_type(tokens)
      res = []
      open_stack = []
      collector = nil
      tokens.each do |text, kind|
        if text == :open && (kind == :string)
          open_stack.push [ kind, [] ]
        else
          if text == :close && kind == open_stack[-1][0]
            kind, collector = open_stack.pop
            text = collector.join
          end
          if open_stack.empty?
            res << [text, kind]
          else
            open_stack[-1][1] << text
          end
        end
      end
      res
    end

    def divide_into_lines(tokens)
      res = []
      line = []
      tokens.each do |token|
        if token[0] == "\n"
          unless line.empty?
            res << Line.new(line, @options)
            line = []
          end
        else
          line << token
        end
      end
      res << Line.new(line, @options) unless line.empty?
      res
    end

    # Given a set of lines, shuffle them across until they meet the left
    # margin
    def bring_to_margin(lines)
      leader = -1
      lines.each do |line|
        leading_spaces = line.leading_spaces

        if leader < 0 || leading_spaces < leader
          leader = leading_spaces
        end
      end

      if leader > 0
        lines.each do |line|
          line.strip_leading_spaces(leader)
        end
      end
      lines
    end

  end

end
