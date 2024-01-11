#encoding: utf-8

class OriginalEntry 
  
  NOISE_WORD_LIST = %w{
    a an at for in of the with from
  }
  
  NOISE_WORDS = Regexp.new(%{^(#{NOISE_WORD_LIST.join("|")}) }, Regexp::IGNORECASE) 
     

  attr_reader :collations
  
  def initialize(i_node)
    split_node(i_node)
    determine_collation
  end

  def collation_key
    @collations.hash.to_s
  end
  
  def get_node_at_level(n)
    @i[n]
  end
  
  # The text we use to display the entry
  def display_for_level(n)
    display(@i[n])
  end
  
  # this is used to verify that two entries that collate to the same place have the same display text
  # It is horrendously inefficient
  
  def full_display
    (0...@i.size).map {|n| display_for_level(n).to_xml } .join(" » ").gsub(/\s+/m, ' ')
  end
   
  
  def <=>(other)
    self.collations <=> other.collations
  end
  
  def has_see_attribute?
    @i.any? {|i| i["see"] || i["see-text"]}
  end
  
  def see
    @i.each do |i|
      return [ :see,      i["see"]]      if i["see"]
      return [ :see_text, i["see-text"]] if i["see-text"]
    end
    nil
  end

  def start_range_attribute
    @i.first["start-range"]
  end

  def end_range?
    @i.first["end-range"]
  end

private

  # Build an array that references from one to three levels of terms
  # in our <i> structure
  def split_node(i_node)
    @i = [ i_node ]
    ii = i_node.css("ii")
    unless ii.empty?   
      ii = ii.first
      @i << ii
      iii = ii.css("iii")
      unless iii.empty?
        @i << iii.first
      end
    end
  end
  
  def determine_collation
    @collations = @i.map {|i| collation_of(i) }
  end

  # At each level, the collation is 
  # - the sortas value if there is one
  # - otherwise the text value of the node, with leading
  #   - leading punctuation followed by \w ignored
  #   - with a|an|at|the|of|in| etc ignored
  #
  # Then, we want to sort 'Hello' and 'hello' together, but
  # with the lower case version second, so we convert all keys to
  # lower case, and add a space to the ends of ones that were originally lower case
  #
  # Finally we add a prefix, so that all symbols sort together, all digits sort together, and
  # all alphas sort together

  def collation_of(node) 
    collation = node["sortas"] || sanitize(text_of(node))
    if collation[0, 1] =~ /[[:upper:]]/
      collation = collation.downcase
    else
      collation = collation + " "
    end
    case collation
    when /^_/    # special case — underscores are not word characters
      "  " + collation
    when /^\w/
      "W " + collation
    when /\^\d/
      "D " + collation
    else 
      "  " + collation
    end
  end
                                                    
  def sanitize(text)
    text = text.strip.gsub(/\s+/m, ' ')
    
    # strip leading noise words
    1 while text.sub!(NOISE_WORDS, '')
  
    # strip leading puncuation
    text.
      sub(/^\W(\w)/, '\1').
      sub(/^“(\w)/, '\1').     # no unicode :(
      sub(/^‘(\w)/, '\1')
  end

  # called with a i, ii, or iii node, we return the text components of our immediate
  # children, but stop when we get to the next index level
  def text_of(node)
    result = []
    node.children.each do |child| 
      break if child.element? && child.name =~ /^iii?$/
      result << child.text.to_s
    end
    result.join
  end    
  
  # Work out a set of nodes that display the content for a particular <i>, <ii>, or <iii>
  def display(node)
    nodes = []
    node.children.each do |child| 
      break if child.element? && child.name =~ /^iii?$/
      nodes << child.dup
    end
    Nokogiri::XML::NodeSet.new(node.document, nodes)
  end
end
