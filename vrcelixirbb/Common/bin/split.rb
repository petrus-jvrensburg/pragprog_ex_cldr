# -*- encoding : utf-8 -*-
require 'nokogiri'
require 'cgi'

EMPTY_MUST_CLOSE = %w{ br link meta img }

def parse(content, document)
  parser = Nokogiri::XML::SAX::Parser.new(document)
  parser.parse(content)
  document
end


class GenericDocument < Nokogiri::XML::SAX::Document

  def initialize(file_name = "UNKNOWN FILE")
    @file_name = file_name
  end

  def error(string)
    if defined?(@chunks) && @chunks.size > 0
      STDERR.puts @chunks.last[-1000..-1]
      STDERR.puts "---------------"
    end
    fail "ERROR: #{@file_name} —  #{string}"
  end

  def warning(string)
    STDERR.puts "WARNING #{string}"
  end
end


# Split a document into chunks starting <h1>, <h2>, or <!-- PP-SPLIT-Hn -->
#

class FullHtmlDocument < GenericDocument

  attr_reader :head, :chunks

  HEAD = %{<?xml version="1.0" encoding="UTF-8"?>\n} + %{<!DOCTYPE html>\n}

  def initialize(file_name)
    super
    @html = []
    @collecting_head = false
    @head = []
    @chunks = []
  end

  def cdata_block(string)
    @html << "<![CDATA[#{string}]]>"
  end

  def characters(string)
    @html << string.gsub(/&/, '&amp;').gsub(/</, '&lt;').gsub(/>/, '&gt;')
  end

  def comment(string)
    if string =~ /^\s*PP-SPLIT-H(\d)\s*$/
      close_current_chunk
    end
  end

  def end_document
    close_current_chunk
  end

  def end_element(name)
    return if EMPTY_MUST_CLOSE.include?(name) || [ "html", "body" ].include?(name)

    @html << "</#{name}>"
    if @collecting_head && name == "head"
      @head = HEAD + @html.join
      @html = []
      @collecing_head = false
    end
  end

  def start_document
  end

  def start_element(name, attrs = [])
    return if name == "body"

    if name == "html"
      attrs = ["xmlns", "http://www.w3.org/1999/xhtml"]
      unless Nokogiri::VERSION < '1.4.4'
        attrs = [ attrs ]
      end
    end

    if start_of_chunk?(name, attrs)
      close_current_chunk
    end

    # Saxon inserts an unwanted Content-Type meta tag for the encoding
    return if  @collecting_head && name == "meta"

    closer = if EMPTY_MUST_CLOSE.include?(name)
               "/>"
             else
               ">"
             end

    if attrs.empty?
      @html << "<#{name}#{closer}"
    else
      @html << "<#{name} #{expand_attrs(attrs)}#{closer}"
    end

    if name == "head"
      @collecting_head = true
    end


  end


  private

  # h1 or h2, or any tag with a pp-chunk in an attribute, unless they have a pp-no-chunk attribute
  def start_of_chunk?(name, attrs)
    attrs = attrs.join
    (name == "h1" || name == "h2" || attrs['pp-chunk']) && !(attrs['pp-no-chunk'])
  end

  def close_current_chunk
    unless @html.empty?
      html = @html.join
      @chunks << html unless html =~ /\A\s*\z/m
      @html = []
    end
  end

  # Apparently Nokogiri switched from returning a flat array to a nested array
  # around about 1.4.4.
  if Nokogiri::VERSION >= '1.4.4'
    # the gsub makes me nervous, but Nokogiri seems to be expanding entities in the resultset
    def expand_attrs(attrs)
      attrs.map do |name, value|
        %{#{name}="#{value.gsub(/&/, '&amp;').gsub(/</, '&lt;').gsub(/>/, '&gt;')}"}
      end.join(" ")
    end
  else
    def expand_attrs(attrs)
      result = []
      until attrs.empty?
        name = attrs.shift
        value = attrs.shift
        result << %{#{name}="#{value}"}
      end
      result.join(" ")
    end
  end
end


# -----------------------------------------------------

class IdFindingDocument < GenericDocument

  attr_reader :ids

  def initialize(file_name)
    @ids = []
    super(file_name)
  end

  if Nokogiri::VERSION < '1.4.4'
    def start_element(name, attrs = [])
      until attrs.empty?
        name = attrs.shift
        value = attrs.shift
        if name == "id"
          @ids << value
          break
        end
      end
    end
  else
    def start_element(name, attrs = [])
      until attrs.empty?
        name, value = attrs.shift
        if name == "id"
          @ids << value
          break
        end
      end
    end
  end
end


# -----------------------------------------------------

class TitleFindingDocument < GenericDocument

  attr_reader :level

  def initialize(file_name)
    @title = []
    @level = 1
    @done = false
    @collecting = false
    super
  end

  # We're looking for
  # <h1 class="chapter-title"><span class="chapter-number">
  #         Chapter
  #         5</span><br></br><span class="chapter-name">Scheduled Builds</span></h1>
  # or
  #  <h2>.....</h2>

  def start_element(name, attrs = [])
    unless @done
      classes = find_class(attrs)

      case
      when name == "br" && classes =~ /end-of-part/
        @level = -1
        @collecting = name
        @title = ["--end-of-part--"]
      when name == "h1" && classes =~ /tp-title/
        @collecting = name
        @level = 0
      when name == "h1" && classes == "part-title"
        @collecting = name
        @level = 1
      when name == "h1"
        @collecting = name
        @level = 2
      when name == "h2"
        @collecting = name
        @level = 3
      when classes =~ /pp-use-as-title-(\d)/
        @collecting = name
        @level = Integer($1)
      else
        ;
      end
    end
  end

  def end_element(name)
    if name == @collecting
      @done = true
      @collecting = false
    end
  end

  def characters(string)
    if string =~ /Chapter\s+(\d+)/m
      @title << "#{$1}:"
    else
      @title << string if @collecting
    end
  end

  if Nokogiri::VERSION >= '1.4.4'
    def find_class(attrs)
      entry = attrs.assoc("class")
      if entry
        entry[1]
      else
        nil
      end
    end
  else
    def find_class(attrs)
      until attrs.size < 2
        name = attrs.shift
        value = attrs.shift
        return value if name == "class"
      end
      nil
    end
  end

  def title
    title = @title.join(" ").gsub(/\s/, ' ').squeeze(' ').strip
#    if title.length.zero?
#      "Copyright"
#    else
      title.sub(/(Part|Chapter|Appendix) \d+/) { "#{$&}:" }
#    end
  end

  def error(*)
  end
end


class TocWriter
  include Enumerable

  class Navpoint
    attr_reader :level

    def initialize(label, filename, title, level, playorder)
      @label = label
      @filename = filename
      @playorder = playorder
      @title = title
      @level = level
      @children = []
    end

    def to_xml(indent = "  ")
      result = %{#{indent}<navPoint id="#{@label}" playOrder="#{@playorder}">\n} +
               %{#{indent}  <navLabel>\n} +
               %{#{indent}    <text>#{CGI::escapeHTML(@title)}</text>\n} +
               %{#{indent}  </navLabel>\n} +
               %{#{indent}  <content src="#{@filename}"/>\n}

      @children.each do |child|
        result << child.to_xml(indent + "  ")
      end

      result << "#{indent}</navPoint>\n"
    end

    def <<(child)
      @children << child
    end
  end

  def initialize(chunks)
    @chunks = chunks
  end

  def write
    navmap = create_navmap
    ncx = File.read("toc.ncx")
    ncx.sub!(%r{<navMap\s*/>}, navmap)
    File.open("toc.ncx", "w") { |f| f.puts ncx }
  end

  def create_navmap

    play_order = 1
    current_level = []

    each do |doc, i|

      next if doc.title.length.zero?

      np = Navpoint.new("navPoint-#{i}",
                        Chunker::full_filename_for(i),
                        doc.title, doc.level,
                        play_order)

      if current_level.empty?
        current_level.push np
      else

        case
        when doc.level == current_level.last.level
          current_level.pop
          current_level.last << np
          current_level.push np

        when doc.level > current_level.last.level
          current_level.last << np
          current_level.push np

        when doc.level == -1 # end of <part>
          current_level.pop while current_level.last.level > 0
          play_order -= 1

        else
          while doc.level <= current_level.last.level
            current_level.pop
          end
          if current_level.empty?
            raise "Bad nesting"
          else
            current_level.last << np
          end
          current_level.push np
        end
      end

      play_order += 1
    end
    ["<navMap>", current_level[0].to_xml, "</navMap>" ].join("\n")
  end

  def single_navpoint(doc, i, play_order)
    %{
    <navPoint id="navPoint-#{i}" playOrder="#{play_order}">
       <navLabel>
          <text>#{CGI::escapeHTML(doc.title)}</text>
       </navLabel>
       <content src="#{Chunker::full_filename_for(i)}"/>
    </navPoint>
    }
  end

  def each
    @chunks.each_with_index do |c, i|
      doc = TitleFindingDocument.new("chunk #{i}")
      parse(c, doc)
      yield doc, i
    end
  end
end




class Chunker

  def initialize(head, chunks)
    @head   = head
    @chunks = chunks
  end

  def update_content_opf

    items = []
    spine = []

    @chunks.each_with_index do |chunk, i|
      unless chunk.start_with?(%{<br class="pp-chunk end-of-part"></br>})
        base_name = Chunker::base_filename_for(i)
        properties = if chunk =~ /class="[^"]*table-of-contents"/
                       'properties="nav" '
                     else
                       ''
                     end

        items <<
          %{<item id="#{base_name}"\n} +
          %{      href="#{Chunker::full_filename_for(i)}"\n} +
          %{      media-type="application/xhtml+xml" #{properties}/>\n}
        spine << %{    <itemref idref="#{base_name}" />}
      end
    end

    content = File.read("content.opf")
    content = content.sub(%r{^\s*<html-items\s*/>}, items.join("\n"))
    content = content.sub(%r{^\s*<spine-items\s*/>}, spine.join("\n"))

    File.open("content.opf", "w") {|f| f.puts content}
  end

  def fixup_idrefs
    # go through each chunk and find all the ids
    id_location = {}
    @chunks.each_with_index do |c, i|
      doc = IdFindingDocument.new("chunk #{i}")
      begin
        parse("<html>#{c}</html>", doc)
      rescue Exception => e
        STDERR.puts c
        File.open("bad.html", "w") {|f| f.puts c}
        raise
      end
      doc.ids.each {|id| id_location[id] = i}
    end
    # Now put a filename in front of all non-local references to
    # these ids.
    @chunks.each_with_index do |c, i|
      id_location.each do |id, location|
        if location != i
          c.gsub!(/"\##{id}"/, %{"#{Chunker::full_filename_for(location)}\##{id}"})
        end
      end
    end
  end

  def create_toc_ncx
    toc = TocWriter.new(@chunks)
    toc.write
  end

  def write_chunks
    @chunks.each_with_index do |content, i|
      File.open(Chunker::full_filename_for(i), "w") do |f|
        f.puts @head
        f.puts "<body>"
        f.puts content
        # google validator complains
        # f.puts '<script src="scripts/book_local.js" type="text/javascript"></script>'
        f.puts '</body></html>'
      end unless content.start_with?(%{<br class="pp-chunk end-of-part"></br>})
    end
  end


  def self.base_filename_for(i)
    "f_%04d" % i
  end

  def self.full_filename_for(i)
    base_filename_for(i) + ".xhtml"
  end
end


doc_file = ARGV[0] || "book.html"
doc = FullHtmlDocument.new(doc_file)
content = File.read(doc_file).chomp.strip
parse(content, doc)

chunker = Chunker.new(doc.head, doc.chunks)
chunker.fixup_idrefs
chunker.update_content_opf
chunker.write_chunks
chunker.create_toc_ncx
