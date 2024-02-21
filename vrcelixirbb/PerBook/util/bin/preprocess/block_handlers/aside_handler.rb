# encoding: utf-8

require_relative "./block_handler.rb"

class AsideHandler < BlockHandler

  Typemap = {
    "info" => { icon: "info" },

  }

  def initialize(options)
    super(options)
    type_name = @options["type"] || @options[0]
    @title = @options["title"]
    @type = Typemap[type_name]

    unless @type
      fail "Don't recognize aside type #{type_name.inspect} in #{options.inspect}.\n" +
        "Valid types are: #{Typemap.keys.join(', ')}"
    end
  end

  def start_of_block(output)
    output.puts %{<table style="outerlines" decoration="zebra">
      <colspec col="1" width="12%" valign="top"/>
      <colspec col="2" width="88%"/>
      }
    if @title && @title.length > 0
      output.puts %{<thead>
        <col span="2" font-size="12pt"><p>#{@title}</p></col>
        </thead>
        }
    end
    output.puts %{<row>
      <col align="left" valign="middle">
      <imagedata fileref="../PerBook/util/images/aside-icons/#{@type[:icon]}.png"
      width="100%"/>
      </col>
      <col valign="middle" markdown="block">\n}
  end

  def end_of_block(output)
    output.puts "</col></row></table>\n\n"
  end

end

GenericBlocks.add_handler("aside", AsideHandler)
