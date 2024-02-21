# encoding: utf-8

class GenericBlocks < Preprocessor

  class BlockInfo
    attr_reader :previous_block
    attr_reader :level
    attr_reader :type
    attr_reader :line
    attr_reader :handler

    def initialize(previous_block, type, level, line, handler)
      @previous_block = previous_block
      @type = type
      @level = level
      @line = line
      @handler = handler
    end

    def pop
      previous_block
    end
  end

  class << self
    @@handler_for = {}

    def add_handler(type, handler)
      @@handler_for[type] = handler
    end
  end

  def parse_args(args)
    return {} unless args
    options = {}
    while args.sub!(/(\w+)=(['"])(.*?)\2/, "")
      options[$1.downcase] = $3
    end

    index = 0
    while args.sub!(/(\w+)/, "")
      options[$1.downcase] = index
      options[index] = $1
      index += 1
    end

    unless args =~ /^\s*$/
      fail "I can't parse the block argument: #{args.inspect}"
    end

    options
  end

  def process(input, output)

    terminator = nil
    current_block = nil

    while line = input.gets
      line.chomp!

      unless line =~ /^\s*:::/
        if current_block
          current_block.handler.handle_line(line, output)
        else
          output.puts line
        end
        next
      end

      if current_block && line =~ /^\s*(:::+)\s*(\/\s*(\w+)\s*)?$/   # end of a block
        level = $1.length - 3
        end_block_type = $3

        unless level == current_block.level
          fail "Incorrect block nesting: #{current_block.line.inspect} is terminated by #{line.inspect}"
        end

        if end_block_type && end_block_type != current_block.type
          fail "End of block type (#{end_block_type}) doesn't match block start (#{current_block.type})"
        end

        current_block.handler.end_of_block(output)
        current_block = current_block.pop
        next
      else
        unless line =~ /^\s*(:::+)\s*(\w+)(\s*(\S.*))?$/
          fail "Missing block type on line #{line.inspect}"
        end
        level = $1.length - 3
        type = $2
        args = $4
        handler = @@handler_for[type.downcase]
        if !handler
          fail "Cannot find handler for block type #{type.inspect}.\n" + 
            "Known handlers are: #{@@handler_for.keys.sort.join(", ")}"
        end
        handler = handler.new(parse_args(args))
        current_block = BlockInfo.new(current_block, type, level, line, handler)
        handler.start_of_block(output)
        next
      end

      if !terminator 
        if line =~ %r{^\s*(:::+)\s*storymap\s*$}i
          terminator = $1
          output.puts "\n\n<storymap markdown=\"block\">"
        else
          output.puts line.chomp
        end

      else
        if line =~ %r{^\s*#{terminator}\s*$}
            terminator = nil
          output.puts "</storymap>\n\n"
        else
          output.puts line.chomp
        end
      end
    end

    if current_block
      fail "Missing closing ':::' for #{current_block.line.inspect}"
    end
  end

end

# handler_dir = File.expand_path("block_handlers", File.dirname(__FILE__))
# Dir["#{handler_dir}/*.rb"].each do |handler|
#   require_relative handler
# end
