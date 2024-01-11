class PipeDumper < Preprocessor

  def map(line)
    STDERR.puts line.inspect
    line
  end

end
