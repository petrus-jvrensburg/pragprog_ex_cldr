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

    while line = gets

      if markdown.nil?
        if line =~ /^\s*<markdown>\s*$/
          markdown = []
        else
          puts line
        end

      else
        if line =~ %r{^\s*</markdown>\s*$}
          markdown.shift if markdown.first =~ /<!\[CDATA\[/
          markdown.pop   if markdown.last  =~ /]]>/
          record_line_numbers do
            dump(markdown.join("\n"))
          end
          markdown = nil
        else
          markdown << line.sub(/markdown!>/, 'markdown>')
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
