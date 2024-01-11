# -*- coding: utf-8 -*-
# We take book.xml and extract out the <i> tags. For each, we add it to our
# entry list. We also use the entry's collation value as the ref-id for the indexing.

require 'nokogiri'
require 'cgi'
require_relative "entry_list"
require_relative "head_list"
require_relative 'original_entry'

class Document
  Opt = Nokogiri::XML::ParseOptions

  def initialize(book_xml)

    if book_xml.start_with?("\ufeff") # bom
      book_xml = book_xml[1..-1]
    end

    @doc = Nokogiri::XML.parse(book_xml, nil, "utf-8") #, Opt::DTDLOAD | Opt::NOENT)
    unless @doc.errors.empty?
      raise Nokogiri::XML::SyntaxError.new(@doc.errors.join("\n"))
    end

    @entry_list =  EntryList.new
    process_index_entries
    create_index_listing
    unless @entry_list.warnings.empty?
      STDERR.puts "\n\n====================== Index Warnings ==========================\n\n"
      STDERR.puts @entry_list.warnings.join("\n\n")
      STDERR.puts
    end
#  rescue Exception => e
#    %w{ code column domain file int1 level line str1 str2 str3 }.each do |a|
#      val = nil
#      val = e.send(a) if e.respond_to?(a)
#      STDERR.puts "#{a}: #{val.inspect}" if val
#    end
#    raise
  end

  def process_index_entries
    @doc.css("i").each do |i|

      entry = OriginalEntry.new(i)

      unless entry.end_range?
        @entry_list.record(entry)
        if false
          margin = Nokogiri::XML::Node.new("marginnote", i.document)
          p = Nokogiri::XML::Node.new("p", margin.document)
          margin.add_child(p)
          p.add_child(CGI.escapeHTML(i.to_xml))
          i.add_next_sibling(margin)
        end
      end
      i["key"] = entry.collation_key
    end
  end

  def create_index_listing
    node = @doc.css("index")

    unless node.empty?
      @head_list = HeadList.from_entry_list(@entry_list)
      @head_list.add_index_to(node.first)
    end
  end

  # This is seriously tacky—I don't seem to be able to add a DOCTYPE, and nokogiri is
  # ignoring the internal subset
  def to_xml
    doc = @doc.to_xml(:save_with => 0)  # the default is FORMAT :(
    unless doc[0,1000] =~ /!DOCTYPE/
      doctype = %{\n<!DOCTYPE #{@doc.internal_subset.name} SYSTEM "local/xml/markup.dtd">\n}
      doc = doc.sub(/\n/, doctype)
    end
    doc
  end

end
