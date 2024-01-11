# encoding: utf-8

# We are the thing that gets added to an entry list. There's one of us for
# each unique entry collation key. We basically wrap an
# OriginalEntry object with a record of
# - the number of different references to this key
# - a list of the see= values for this key

class Entry
  
  include Comparable
  
  attr_reader :original_entry
  
  def initialize(original_entry)
    @original_entry = original_entry
    @has_page_number = !@original_entry.has_see_attribute?
    @sees = []
    @ranges = []
    if original_entry.has_see_attribute?
      @sees << original_entry.see
    end
    if range = original_entry.start_range_attribute
      @ranges << range
    end
  end
  
  def merge(original_entry)
    if original_entry.has_see_attribute? 
      @sees << original_entry.see
    else
      @has_page_number = true
      if range = original_entry.start_range_attribute
        @ranges << range
      end
    end
  end
  
  def has_different_display_to(other_entry)
    mine = @original_entry.full_display
    hers = other_entry.full_display
    if mine == hers
      false
    else
      %{Different display text for entries that collate to #{self.collation_string}:\n} +
      %{         #{mine.inspect}\n} +
      %{    vs.  #{hers.inspect}}
    end
  end
  
  # only used for display—never use for sorting
  def collation_string
    @collation_string ||= @original_entry.collations.join("»")
  end                     
  
  def <=>(other)
    @original_entry <=> other.original_entry
  end
  
  def head_term 
    @original_entry.collations.first
  end
  
  def see
    @sees
  end
  
  def first_letter
    letter = head_term[2,1]
    case letter
    when /\d/
      "Digits"
    when "_"
      "Symbols"
    when /\w/
      letter.upcase
    else
      "Symbols"
    end
  end   
  
  def collation_key
    @original_entry.collation_key
  end
  
  def collation_for_level(level)
    @original_entry.collations[level]
  end   
  
  def display_for_level(level)
    @original_entry.display_for_level(level)
  end
  
  def highest_level
    @original_entry.collations.size - 1
  end 
  
  def has_page_number? 
    @has_page_number
  end
end  
