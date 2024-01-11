# encoding: utf-8

require_relative 'formatters/pip'


class RougeCode
  class Highlight

    attr_reader :options

    def initialize(source, language, options={}, preprocessor=nil)
      @preprocessor = preprocessor

      @options = options
      @options["language"] = language ? language.intern : nil

      @source = source
        .sub(/\a(\s*\n)+/, '')
        .sub(/[\s\n]+\z/, '')

      @literals = [ ]

      raise "Empty source" if @source.empty?

      @source << "\n" unless @source.end_with?("\n")
    end

    def to_pml
      lc = lexer_class((@options["language"] || :plaintext).intern)

      lexer = lc.new({})

      formatter = Rouge::Formatters::Pip.new({preprocessor: @preprocessor, options: @options})

      result = []

      source = remove_literals_from_source(@source)

      # Debugging tokens - uncomment to see tokens displayed
      #lexer.lex(source).each do |l|
        #STDOUT.puts l.inspect
      #end

      formatter.format(lexer.lex(source)) do |line|
        result << line
      end

      add_literals_back(result.join)
    end

    private

    def lexer_class(language)
      lexer = Rouge::Lexer.find(language)
      unless lexer
        STDERR.puts "Unknown language '#{language}'"
        lexer = Rouge::Lexer.find(:plaintext)
      end
      lexer
    end

    def remove_literals_from_source(source)
      # source.gsub(%r{<literal[^>]*>.*?</literal[^>]*>}i) do |literal|
      #  @literals << literal.gsub(/literal:/, '')
      # "#{LITERAL * @literals.size}#{END_LITERAL}"
      source.gsub(%r{</?literal[^>]*>}i) do |literal|
        @literals << literal.sub(/literal:/, '')
        "#{LITERAL * @literals.size}#{END_LITERAL}"
      end
    end


    def add_literals_back(result)
      result.gsub(/#{LITERAL}+#{END_LITERAL}/o) do |match|
        @literals[match.length - 2]
      end
    end

  end

end
