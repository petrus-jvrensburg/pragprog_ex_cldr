# We represent the list of <i>...</i>s in the original document 

require_relative 'entry'

class EntryList
  
  include Enumerable
  
  attr_reader :errors, :warnings
  
  def initialize
    @entries  = {}
    @warnings = []
    @errors   = []
  end
  
  # We warn if
  # - two entries have the same collation but different display text
  def record(original_entry)
    key = original_entry.collation_key
    if existing = @entries[key]
      if message = existing.has_different_display_to(original_entry)  
        @warnings << message
      end
      existing.merge(original_entry)
    else
      @entries[key] = Entry.new(original_entry)
    end
  end


  
  def each
    if block_given?
      @entries.each {|k, e| yield e}
    else  
      @entries.each
    end
  end
end
