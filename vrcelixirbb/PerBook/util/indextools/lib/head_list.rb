#encoding: utf-8
# We're the output side—the list of entries in the index itself
# There's one head entry for each top-level index item, so
#
#     Fruit, 10
#        apple, 11
#        pear,  22, 33
#
# is represented by a single head entry

require_relative 'head'

class HeadList

  N = Nokogiri::XML::Node  
  
  attr_reader:list  # for debugging
  
  def self.from_entry_list(entry_list)
    head = nil
    list = new
    
    entry_list.sort.each do |entry|
      if head.nil? || head.head_term != entry.head_term
        head = Head.new
        list << head
      end
      head << entry
    end 
    list
  end
              
  def initialize
    @list = []
  end
         
  def <<(head)
    @list << head
  end  
     
 
  # add an index listing as a child of +node+
  def add_index_to(node)
    listing = N.new("index-listing", node.document)
    node.add_child(listing)

    current_letter = nil
    alpha_section = nil
    @list.each do |head|
      if head.first_letter != current_letter
        current_letter = head.first_letter
        alpha_section = N.new("alpha-head", node.document)
        alpha_section["heading"] = current_letter
        listing.add_child(alpha_section)
      end
      head.add_to_index(alpha_section)
    end
  end
end
