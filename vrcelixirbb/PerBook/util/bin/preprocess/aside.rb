# encoding: utf-8

class Aside < Preprocessor

  def process(input, output)

    state = :not_in_aside

    while line = input.gets

      case state
      when :not_in_aside
        if line =~ %r{^\s*\[aside\s+(\w+)(?:\s+([^\]]+))?\]}i
          icon = $1
          title = $2
          state = :in_aside
          output.puts %{<table style="outerlines" decoration="zebra">
          <colspec col="1" width="12%"/>
          <colspec col="2" width="88%"/>
          }
          if title
            title = title.sub(%r{</p>$}, '').strip
            if title.length > 0
              output.puts %{<thead>
             <col span="2" font-size="12pt"><p>#{title}</p></col>
            </thead>
            }
            end
          end
          output.puts %{<row>
             <col align="left" valign="middle">
               <imagedata fileref="../PerBook/util/images/aside-icons/#{icon}.png"
                          width="100%"/>
             </col>
             <col valign="middle" markdown="block">\n}
        else
          output.puts line.chomp
        end

      else
        if line =~ %r{^\s*\[/aside\]\s*$}i
          state = :not_in_aside
          output.puts "</col></row></table>\n\n"
        else
          output.puts line.chomp
        end
      end
    end
  end

end
