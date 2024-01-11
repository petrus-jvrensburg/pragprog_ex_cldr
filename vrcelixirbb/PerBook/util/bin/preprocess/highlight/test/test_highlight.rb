require_relative 'test_helper'

require_relative '../lib/pml_code/highlight'

class TestHighlight < TestHelper

  context "no content" do
    should "raise an exception" do
      assert_raises(RuntimeError) {  PmlCode::Highlight.new("", :ruby) }
      assert_raises(RuntimeError) {  PmlCode::Highlight.new("  ", :ruby) }
      assert_raises(RuntimeError) {  PmlCode::Highlight.new("\n\n", :ruby) }
      assert_raises(RuntimeError) {  PmlCode::Highlight.new(" \n \n", :ruby) }
    end
  end
  
  
  context "one simple line" do
    setup do
      @encoder = PmlCode::Highlight.new("a", :ruby)
    end
    should "generate one codeline" do
      assert_lines "<codeline>a</codeline>\n", @encoder.to_pml
    end
  end

  context "two simple lines with a trailing newline" do
    setup do
      @encoder = PmlCode::Highlight.new("a\nb\n", :ruby)
    end
    should "generate two codelines" do
      assert_lines "<codeline>a</codeline>\n<codeline>b</codeline>\n", @encoder.to_pml
    end
  end

  context "a line containing less than and ampersand" do
    setup do
      @encoder = PmlCode::Highlight.new("a & b < c # & <", :ruby)
    end
    should "be escaped" do
      assert_lines "<codeline>a &amp; b &lt; c <cocomment># &amp; &lt;</cocomment></codeline>\n", @encoder.to_pml
    end
  end
  
  context "some actual code" do
    setup do
      @encoder = PmlCode::Highlight.new(code(%{
        def fred
          a = "cat"
        end}), :ruby)
    end
    should "generate two codelines" do
      assert_lines code(%{
        <codeline><cokw>def</cokw> fred</codeline>
        <codeline>  a = <costring>"cat"</costring></codeline>
        <codeline><cokw>end</cokw></codeline>
        }), @encoder.to_pml
    end
  end
  
  context "highlights" do
    setup do
      @encoder = PmlCode::Highlight.new(code(%{
         line 1
         # START_HIGHLIGHT  
         line 2
         line 3
         # END_HIGHLIGHT
         line 4
      }), :ruby)
    end
    should "be reflected in two codelines" do
      assert_lines code(%{
        <codeline>line 1</codeline>
        <codeline highlight="yes">line 2</codeline>
        <codeline highlight="yes">line 3</codeline>
        <codeline>line 4</codeline>
        }), @encoder.to_pml
    end
  end


  context "cross reference targets" do
    setup do
      @encoder = PmlCode::Highlight.new(code(%{
         line 1
         line 2 # <label id="one"/>
         line 3 # comment <label id="two"/>
         line 4
      }), :ruby)
    end
    should "turn on line numbering and be reflected in two codelines" do
      assert_lines code(%{
        <codeline prefix="Line 1">line 1</codeline>
        <codeline prefix="2" id="one" lineno="2">line 2 </codeline>
        <codeline prefix="3" id="two" lineno="3">line 3 <cocomment># comment </cocomment></codeline>
        <codeline prefix="4">line 4</codeline>
        }), @encoder.to_pml
    end
  end
  
  context "callout targets" do
    setup do
      @encoder = PmlCode::Highlight.new(code(%{
         line 1
         line 2 # <callout id="one"/>
         line 3
         line 4 # comment <callout id="two"/>
      }), :ruby)
    end
    should "be reflected in two codelines" do
      assert_lines code(%{
        <codeline>line 1</codeline>
        <codeline id="one" calloutno="1">line 2 </codeline>
        <codeline>line 3</codeline>
        <codeline id="two" calloutno="2">line 4 <cocomment># comment </cocomment></codeline>
        }), @encoder.to_pml
    end
  end

  context "If the verbatim option is set" do
    setup do
      @encoder = PmlCode::Highlight.new(code(%{
         line 1
         line 2 # <callout id="one"/>
         line 3
         line 4 # comment <label id="two"/>
      }), :ruby, :verbatim => true)
    end
    should "not honor cross reference targets" do
      assert_lines code(%{
        <codeline>line 1</codeline>
        <codeline>line 2 <cocomment># &lt;callout id="one"/></cocomment></codeline>
        <codeline>line 3</codeline>
        <codeline>line 4 <cocomment># comment &lt;label id="two"/></cocomment></codeline>
        }), @encoder.to_pml
    end
  end 
   

end
