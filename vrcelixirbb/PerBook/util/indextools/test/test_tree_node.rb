require_relative 'indexer_test'
require_relative '../lib/head'

class Head
  class TreeNode
    attr_reader :children
  end
end

class TestTreeNode < IndexerTest

  context "A TreeNode based on one single-level term" do
    setup do 
      @node = Head::TreeNode.new(entry("<i>one</i>"))
    end
    
    should "have the term's collation" do
      assert_equal "one ", @node.collation
    end
    
    should "have the correct display text" do
      assert_equal "one", @node.display.to_xml
    end 
    
    should "have a page_ref" do
      assert @node.page_ref
    end
  end
  
  context "A TreeNode based on one single-level term with a see=" do
    setup do 
      @node = Head::TreeNode.new
      @node.add(entry('<i see="123">one</i>'))
    end
    should "not have a page_ref" do
      refute @node.page_ref
    end 
    should "list the see" do
      assert_equal [ "123" ], @node.sees
    end 
    
    context "which has a second index term with a see= added" do
      setup do 
        @node.add(entry('<i see="456">one</i>'))
      end

      should "not have a page_ref" do
        refute @node.page_ref
      end 

      should "list both the sees" do
        assert_equal [ "123", "456" ], @node.sees
      end 
      
    end
  end   
  
  context "A TreeNode with two entries, one a child of another" do 
    setup do
      @node = Head::TreeNode.new
      @node.add(entry('<i>one</i>'))
      @node.add(entry('<i>one<ii>two</ii></i>'))
    end
    
    should "have the top level entry as the main collation" do
      assert_equal "one ", @node.collation
    end

    should "have the second level entry as the child" do
      children = @node.children
      assert_equal 1, children.size 
      assert_equal "two ", children.keys.first
    end

  end
  
  
end