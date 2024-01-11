#                          -*- encoding: utf-8 -*-
#
# Given a book.xml file, look for all the cite="xxx" attributes.
# Find the entries in the bibliography that match, and extract them out into 
# a little mini-bibliography, adding in the actual line to be written
# in the appendix itself. 
#
# The contents of this generated bibliography file are merged into
# back into the book.xml, which is then written out
#
#
# ruby generate_bibliography  bib.xml...  <book.xml >bib_extract.xml
#

if RUBY_VERSION < "1.9"
#  require 'rubygems'
#  gem 'nokogiri'

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

#if RUBY_PLATFORM =~ /java/
#  ENV["GEM_HOME"] = ENV["GEM_PATH"] = nil
#end

require 'nokogiri'
require_relative 'annotator'



def error(msg)
  STDERR.puts "\n\n" + "-"*50 + "\nBibilography error:\n\t#{msg}\n\n"
  exit(99)
end
  


# Stream-parse the book and extract all the cite= attributes
class BookParser < Nokogiri::XML::SAX::Document

  def initialize
    @cites = {}
  end

  def parse(stream)
    parser = Nokogiri::XML::SAX::Parser.new(self)
    parser.parse(stream.read)
  end

  if Nokogiri::VERSION < '1.4.4'
    def start_element(name, attrs)
      return if attrs.empty?
      if cite = attrs.find_index("cite")
        tag = attrs[cite+1]
        @cites[tag] = 1
      end
    end
  else
    def start_element(name, attrs)
      return if attrs.empty?
      if cite = attrs.assoc("cite")
        tag = cite[1]
        @cites[tag] = 1
      end
    end
  end

  def citations
    @cites.keys
  end
end




class BibParser

  PUBLISHERS = {}
  
  # Find the citations we use from the bibliography and extract them
  # Return the updated citation list

  def process_citations(bib, citations)
    result = []

    
    unless citations.empty?
      @parser = Nokogiri::XML(bib)
   
      find_publishers_in(@parser)
      
      criteria = citations.map {|c| %{@tag="#{c}"} }.join(" or ")

      @parser.xpath(%{//*[#{criteria}]}).each do |entry|
        tag = entry["tag"]
        # only do each tag once
        citations.delete(tag)
        result << annotate(entry)
      end
    end
    result
  end

  # dispatch to an annotator depending on the type of this node (book, web, article, ...)
  def annotate(entry)
    Annotator.process(@parser, PUBLISHERS, entry)
  end


  # extract the <publishers> block into name[, address], and return as a hash keyed by id
  def find_publishers_in(doc)
    doc.xpath("//publishers/house").each do |house|
      id = house["xml:id"] || house["id"]   # libxml uses id, xerces xml:id
      details = [ house.xpath("name"), house.xpath("address") ].compact.map {|d| d.text}.join(", ")
      PUBLISHERS[id] = details
    end
  end
end


book = BookParser.new
book.parse(STDIN)

result = []
citations = book.citations

until ARGV.empty?
  bib = BibParser.new
  result.concat(bib.process_citations(File.read(ARGV.shift), citations))
end

doc = Nokogiri::XML::Document.new
extract = Nokogiri::XML::Node.new("bib-extract", doc)

result.sort_by {|r| r["label"].downcase}.each do |entry|
  extract.add_child(entry)
end

doc.add_child(extract)

puts doc.to_xml(:encoding => "UTF-8")

