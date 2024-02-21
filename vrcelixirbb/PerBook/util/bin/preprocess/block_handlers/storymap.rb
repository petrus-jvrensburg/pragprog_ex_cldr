# encoding: utf-8
require_relative "./block_handler.rb"

class Storymap < BlockHandler

  def start_of_block(output)
    output.puts "\n\n<storymap markdown=\"block\">"
  end

  def end_of_block(output)
    output.puts "</storymap>\n\n"
  end

end

GenericBlocks.add_handler("storymap", Storymap)
