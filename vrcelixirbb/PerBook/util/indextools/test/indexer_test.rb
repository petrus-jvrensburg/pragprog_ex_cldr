require 'test/unit'
require 'shoulda'
require 'nokogiri'

require_relative "../lib/original_entry"
require_relative "../lib/entry_list"
require_relative "../lib/entry"

# unless defined?(SimpleCov)
#   require 'simplecov'
#   SimpleCov.start
# end   


module Indexer; end

class IndexerTest < Test::Unit::TestCase

  include Indexer

  # Create an xml fragment from a string
  def i_from_string(string)
    Nokogiri::XML.fragment(string).children.first
  end

  
  # original_entry("<i>....</i>")
  def original_entry(string) 
    OriginalEntry.new(i_from_string(string))
  end
             
  def entry(string)
    Entry.new(original_entry(string))
  end 
  
  def entry_list(*strings)
    entry_list = EntryList.new
    strings.each {|s| entry_list.record(original_entry(s)) }
    entry_list
  end
  
end