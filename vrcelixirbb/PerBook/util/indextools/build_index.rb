# encoding: utf-8

# Scan a book.xml file for index entries. Add a unique reference to each.
#
# At the end, write back out the modified book.xml, adding to it the
# actual index
#


if $0 == __FILE__

  unless respond_to?(:require_relative)
    def require_relative(relative_feature)
      c = caller.first
      fail "Can't parse #{c}" unless c.rindex(/:\d+(:in `.*')?$/)
      file = $`
      if /\A\((.*)\)/ =~ file # eval, etc.
        raise LoadError, "require_relative is called in #{$1}"
      end
      absolute = File.expand_path(relative_feature, File.dirname(file))
      require absolute
    end
  end

  class Preprocessor
    def initialize
      @input = STDIN
      @output = STDOUT
    end
  end


  if RUBY_PLATFORM =~ /java/
    ENV["GEM_HOME"] = ENV["GEM_PATH"] = nil
  end

  def puts_in_bold(msg)
    puts msg
  end
end


class BuildIndex < Preprocessor


  def process(input, output)
    require 'nokogiri'                  # lazy load to speed rake start

    require_relative 'lib/document'
    content = input.read

    doc = Document.new(content)
    doc.to_xml.split(/\n/).each {|line| output.puts line}


  # If we get an error processing, we'll punt, because it will
  # get picked up during validation
  rescue Nokogiri::XML::SyntaxError => e
    # STDERR.puts "here"
    # STDERR.puts e.message
    content.split(/\n/).each {|line| output.puts line}
  end

end


if $0 == __FILE__
  BuildIndex.new.process(STDIN, STDOUT)
end
