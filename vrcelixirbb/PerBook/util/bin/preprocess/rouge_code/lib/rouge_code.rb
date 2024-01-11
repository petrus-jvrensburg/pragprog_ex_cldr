# encoding: utf-8

require 'rouge'

Dir.chdir(File.dirname(__FILE__)) do
  Dir.glob("rouge_code/lexers/*.rb").each do |lexer|
    require_relative lexer
  end
end



class RougeCode < Preprocessor   ## set the parent class for what follows

  # LITERAL     = "\013"   # should be a whitespace in any lexer
  # END_LITERAL = "\014"

  LITERAL     = "\f"   # should be a whitespace in any lexer
  END_LITERAL = "\g"
  LITERAL_PROXY = /#{LITERAL}+#{END_LITERAL}/o
end

require_relative 'rouge_code/code_block_processor'


class RougeCode

  def process(input, output)
    tag = "(nested-code|code|ruby|result)"
    while line = input.gets
      if line =~ /^\s*(\[)#{tag}(\s|\])/o || line =~ /^\s*(\<)#{tag}(\s|\>)/o
        opener = $1
        cbp = RougeCode::CodeBlockProcessor.new(line, input, opener, self)
        record_line_numbers do
          cbp.process do |line|
            output.puts line
          end
        end
      else
        output.puts line
      end
    end
  end

end
