require_relative 'test_helper'

require_relative '../lib/pml_code/highlight'

module PmlCode
  class Highlight
    attr_reader :lines, :tokens
  end
end

# Test the shell scanner
class TestShell < TestHelper

  context "one simple line" do
    setup do
      @encoder = PmlCode::Highlight.new("ruby a.rb", :shell)
    end
    should "look like output" do
      assert_equal [ ["ruby",:ident], [" ", :space], ["a.rb", :other] ], @encoder.tokens
    end
  end

  context "line with keywords" do
    setup do
      @encoder = PmlCode::Highlight.new("if a;then;hello;fi", :shell)
    end
    should "look like output" do
      assert_equal [["if", :reserved],
       [" ", :space],
       ["a", :ident],
       [";", :metacharacter],
       ["then", :reserved],
       [";", :metacharacter],
       ["hello", :ident],
       [";", :metacharacter],
       ["fi", :reserved]], @encoder.tokens
    end
  end
 
  context "line with string" do
    setup do
      @encoder = PmlCode::Highlight.new("echo 'a b c'", :shell)
    end
    should "look like output" do
      assert_equal [["echo", :reserved],
       [" ", :space],
       [:open, :string],
       ["'", :delimiter],
       ["a b c", :content],
       ["'", :delimiter],
       [:close, :string]], @encoder.tokens
    end
  end
  
  context "line with string containing an escape" do
    setup do
      @encoder = PmlCode::Highlight.new("echo 'a \\' c'", :shell)
    end
    should "look like output" do
      assert_equal [["echo", :reserved],
       [" ", :space],
       [:open, :string],
       ["'", :delimiter],
       ["a \\' c", :content],
       ["'", :delimiter],
       [:close, :string]], @encoder.tokens
    end
  end
end