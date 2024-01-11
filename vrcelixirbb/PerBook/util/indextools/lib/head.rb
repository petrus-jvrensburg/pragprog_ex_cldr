# We represent a single index head (that is a top level entry and any and all subentries

class Head

  Node = Nokogiri::XML::Node

  class TreeNode

    attr_reader :collation, :display, :page_ref, :sees

    def initialize(entry=nil, level=0)
      @collation = nil
      @display   = nil
      @children  = {}
      @sees      = []

      add(entry, level) if entry
    end

    def add(entry, level=0)
      @collation ||= entry.collation_for_level(level)
      @display   ||= entry.display_for_level(level)
      if entry.highest_level > level
        add_child(entry, level+1)
      else
        add_details_from(entry)
      end
    end


    def add_child(entry, level)
      collation = entry.collation_for_level(level)
      @children[collation] ||= TreeNode.new(entry, level)
    end

    def each_child
      @children.sort_by {|collation,*| collation}.each {|collation, child| yield child}
    end

    def add_details_from(entry)
      if entry.has_page_number?
        @page_ref = entry.collation_key
      end
      if see = entry.see
        @sees.concat(see)
      end
    end

    def add_to_node(node, doc, prefix="i")
      prefix += "i"
      if @page_ref
        node["key-ref"] = @page_ref
      end
      unless @sees.empty?
        see_list = Node.new("i-see-list", doc)
        node.add_child(see_list)
        @sees.sort.each do |kind, text|
          see = Node.new("i-see", doc)
          see_list.add_child(see)
          if kind == :see
            see["see"] = text
          else
            see["see-text"] = text
          end
        end
      end
      node.add_child(@display)
      each_child do |child|
        child_node = Node.new("#{prefix}-entry", doc)
        node.add_child(child_node)
        child.add_to_node(child_node, doc, prefix)
      end
    end

    # Look for heads that have <i>one<ii>two</ii></i> but don't have
    # a separate entry for <i>one</i>, and map them into
    # <i>one, two</i>
    def optimize
      @children.each {|_,child| child.optimize}
      if @page_ref.nil? && @children.size == 1
        child = @children.values.first
        unless @display.first
          raise inspect
        end
        doc = @display.first.document
        @display << Nokogiri::XML::Text.new(", ", doc)
        @display = Nokogiri::XML::NodeSet.new(doc, @display + child.display)
        @collation += ", #{child.collation}"
        @page_ref = child.page_ref
        @children = {}
      end
    end

  end

  attr_reader :first_letter

  def initialize
    @head = nil
    @first_letter = nil
  end

  def <<(entry)
    if @head.nil?
      @head = TreeNode.new()
      @first_letter = entry.first_letter.upcase
    end
    @head.add(entry)
  end

  def head_term
    @head.collation
  end

  def add_to_index(node)
    @head.optimize
    doc = node.document
    i = Node.new("i-entry", doc)
    node.add_child(i)
    @head.add_to_node(i, doc)
  end

end
