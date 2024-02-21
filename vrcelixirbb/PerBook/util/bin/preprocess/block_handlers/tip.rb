# encoding: utf-8

require_relative "./block_handler.rb"

class Tip < BlockHandler

  def initialize(options)
    super(
      options,
      "tip",
      {
        "title" => :string,
      })
    title = @options["title"] || @options.join(" ")
  end

  def start_of_block(output)
    output.puts "\n\n<tip markdown=\"block\">"
    if title = @options["title"]
      output.puts "<title markdown=\"span\">#{escape(title)}</title>"
    end
    # In the body of the book we ignore the top content
    # output.puts "<tip-content markdown=\"block\">"
  end

  def end_of_block(output)
    # output.puts "</tip-content>"
    output.puts "</tip>\n\n"
  end

end

GenericBlocks.add_handler("tip", Tip)

