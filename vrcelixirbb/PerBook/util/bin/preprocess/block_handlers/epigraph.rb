# encoding: utf-8

require_relative "./block_handler.rb"

class Epigraph < BlockHandler

  def initialize(options)
    super(options)
    unless @options["name"]
      fail "::: epigraph is missing the 'name=\"some body\"' attribute"
    end
  end

  def start_of_block(output)
    output.puts "\n\n<epigraph markdown=\"block\">"
    output.puts "<name markdown=\"span\">#{escape(@options["name"])}</name>"
    if title = @options["title"]
      output.puts "<title markdown=\"span\">#{escape(title)}</title>"
    end
    if date = @options["date"]
      output.puts "<date markdown=\"span\">#{escape(date)}</date>"
    end
  output.puts "<epitext markdown=\"block\">"
  end

  def end_of_block(output)
    output.puts "</epitext>\n\n"
    output.puts "</epigraph>\n\n"
  end

end

GenericBlocks.add_handler("epigraph", Epigraph)

