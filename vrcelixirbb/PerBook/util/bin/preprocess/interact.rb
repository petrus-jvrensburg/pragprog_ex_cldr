# encoding: utf-8
#
# Look for blocks like
#
#   <interact>
#     Enter your name: 
#     %%%Dave Thomas
#     Hi, Dave Thomas 
#     Your name has 2 words in it
#   </interact>
#
# Lines starting with three percent signs are user input, and are shown in bold with an
# arrow.
#

require 'cgi'

Encoding.default_external = "utf-8" if defined?(Encoding)

class Interact < Preprocessor
  # remove trailing newline, and convert tabs to spaces
  def normalize(line)
    line = line.chomp
    1 while line.sub!(/\t+/) { ' ' * ($&.length*8 - $`.length % 8) }
    line
  end

  def bring_to_margin(lines)
    # find shortest indent in non-blank lines
    indent = lines.grep(/\S/).map {|l| l =~ /^(\s*)/; $1.length}.min
    if indent && indent > 0
      lines.each do |line|
        line[0,indent] = ''
      end
    end
  end

  def escape(line)
    pure_line = CGI::escapeHTML(line)
    pure_line.gsub(/&lt;literal:(.*?)&gt;/, '<\1>').gsub(%r{&lt;\/literal:(.*?)&gt;}, '</\1>')
  end

  def dump(interaction)
    bring_to_margin(interaction)
    prefix = "out"

    puts %{<processedcode showname="no">}
    interaction.each do |line|
      result = []
      result << %{<codeline}
      if line.sub!(/^%%%/, '')
        result << %{ prefix="in">}
        result << "<cokw>"
        result << escape(line)
        result << "</cokw>"
        result << "</codeline>\n"
        puts result.join
        prefix = "out"
      else
        result << %{ prefix="#{prefix}"} if prefix
        result << ">"
        result << escape(line)
        result << "</codeline>"
        puts result.join
        prefix = nil
      end
    end
    puts "</processedcode>"
  end



  def process(*)
    interaction = nil
    
    while line = gets
      if interaction.nil?
        if line =~ /^\s*<interact>\s*$/
          interaction = []
        else
          puts line
        end
        
      else
        if line =~ %r{^\s*</interact>\s*$}
          record_line_numbers do
            dump(interaction)
          end
          interaction = nil
        else
          interaction << normalize(line)
        end
      end
      
    end
    
    fail "Unterminated <interact>" if interaction
  end

end
