# encoding: utf-8

require_relative "./block_handler.rb"


# Syntax is:
#
# ::::: yourturn
# ::::  question      -+  
# :::   answer         | repeat
# :::   /answer        |
# ::::  /question     -+
# ::::: /yourturn
#
# At the end of the document, will generate a list of all the answers
#
#   ::: dumpanswers
#   :::

class Yourturn < BlockHandler
  @count = 0
  @answers = []

  class << self
    attr_accessor :count, :answers
  end

  def start_of_block(output)
  end

  def end_of_block(output)
  end
end

class Question < BlockHandler
  def initialize(options)
    super(options)
    @type = @options["type"] || @options[0] || "Exercise"
    Yourturn.count += 1
    @qno = Yourturn.count
    @question_lines = []
  end

  def start_of_block(output)
  end

  def end_of_block(output)
    if Yourturn.answers[@qno]
      output.puts   %{<p id="exercise-#{@qno}">}
      output.puts          %{<dont-use-embolden>#@type #{@qno}</dont-use-embolden> }
      output.puts      %{(<xref linkend="answer-#{@qno}">my thoughts</xref>)}
      output.puts   %{</p>}
    else
      output.puts  %{<p id="exercise-#{@qno}">}
      output.puts    %{<dont-use-embolden>#@type #{@qno}</dont-use-embolden>}
      output.puts  %{</p>}
    end
    output.puts "\n"
    @question_lines.each do |line|
      output.puts line
    end
    output.puts "\n"
  end

  def handle_line(line, output)
    @question_lines << line
    nil
  end
end

class Answer < BlockHandler
  def initialize(options)
    super(options, "answer", {})
    @ano = Yourturn.count
    @answer_lines = []
    Yourturn.answers[@ano] = @answer_lines
  end

  def start_of_block(output)
    @answer_lines << 
      %{<p id="answer-#@ano">} <<
        %{<dont-use-embolden>Answer #@ano</dont-use-embolden>} <<
      %{</p>} <<
      %{\n}
  end

  def end_of_block(output)
  end

  def handle_line(line, output)
    @answer_lines << line
  end
end

class Dumpanswers < BlockHandler
  def start_of_block(output)
    Yourturn.answers.each.with_index do |answer, index|
      if answer
        answer.each do |line|
          output.puts line
        end
        output.puts "\n"
      end
    end
  end

  def end_of_block(output)
  end
end

GenericBlocks.add_handler("yourturn",    Yourturn)
GenericBlocks.add_handler("question",    Question)
GenericBlocks.add_handler("answer",      Answer)
GenericBlocks.add_handler("dumpanswers", Dumpanswers)

