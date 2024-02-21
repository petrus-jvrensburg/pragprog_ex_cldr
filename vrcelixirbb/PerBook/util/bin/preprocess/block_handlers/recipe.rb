# encoding: utf-8

require_relative "./block_handler.rb"

class Recipe < BlockHandler

  ARGS = {
    "title" => :string,
    "level" => :string,
    "intoc" => :bool,
    "break" => :bool,
    "style" => :bool,
    "stubout" => :bool,
    "line" => :bool
  }

  def initialize(options)
    super( options, "recipe", ARGS)
    unless @options["title"]
      fail "::: recipe is missing the 'title=\"something interesting\"' attribute"
    end
  end

  def start_of_block(output)
    if level = @options["level"]
      @options["level"] = level.length if level =~ /^#+$/
    end

    xml_options = %w{level intoc break style stubout line}.reduce([]) do |result, option|
      if @options.has_key?(option)
        case ARGS[option]
        when :string, :bool
          result << %{#{option}="#{@options[option]}"}

        else 
          fail "Bad option #{option}"
        end 
      end 
      result
    end

    output.puts "\n\n<recipe #{xml_options.join(' ')} markdown=\"block\">"
    if title = @options["title"]
      output.puts "<title markdown=\"span\">#{escape(title)}</title>"
    end
  end

  def end_of_block(output)
    output.puts "</recipe>\n\n"
  end

end

GenericBlocks.add_handler("recipe", Recipe)

