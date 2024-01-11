class PmlCode < Preprocessor   ## set the parent class for what follows
end

require_relative 'pml_code/code_block_processor'

class PmlCode

  def process(input, output)
    while line = input.gets
      if line =~ /^\s*<(nested-code|code|ruby|result)(\s|>)/
        cbp = PmlCode::CodeBlockProcessor.new(line, input, self)
        record_line_numbers do
          output.puts cbp.process
        end
      else
        output.puts line
      end
    end
  end

end
