# encoding: utf-8
#
#  Replace the contents of markdown between <markdown> and <markdown> with
#  the equivalent PML

require 'markdown/convertor'

class Markdown < Preprocessor

  def dump(markdown)
    doc =  Kramdown::Document.new(markdown, :parse_block_html => true)

    unless doc.warnings.empty?
      fatal_error(doc.warnings.join("\n\n"))
    end

    doc.to_pml.split(/\n/).each do |line|
      puts line
    end
  end

def process(*)

  markdown = nil
  nesting  = 0

  while line = gets
    if line =~ /^\s*<markdown>\s*$/
      nesting += 1
      markdown ||= []
    elsif line =~ %r{\s*</markdown>\s*$}
      if nesting < 1
        fail "Extra '</markdown>' tag found"
      end
      nesting -= 1
      if nesting.zero?
        markdown.shift if markdown.first =~ /<!\[CDATA\[/
        markdown.pop   if markdown.last  =~ /]]>/
        record_line_numbers do
          dump(markdown.join("\n"))
        end
        markdown = nil
      end
    else
      if markdown
        markdown << line.sub(/markdown!>/, 'markdown>')
      else 
        puts line
      end
    end
    end 
    fail "Unterminated <markdown>" if markdown
  end

end
__END__
given: list with spaces
  * now is

  * the time
expect:
  now is
  the time
