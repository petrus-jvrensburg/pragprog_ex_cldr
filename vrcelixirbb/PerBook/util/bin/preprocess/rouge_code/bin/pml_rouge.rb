
class Preprocessor
  def record_line_numbers
    yield
  end
end

require_relative '../lib/rouge_code.rb'  # for now...

RougeCode.new.process(STDIN, STDOUT)
