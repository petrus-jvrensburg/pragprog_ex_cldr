require_relative 'test_helper'
require 'stringio'
require_relative '../lib/pml_code/code_block_processor'

module PmlCode
  class CodeBlockProcessor
    attr_reader :code_options
  end
end

class TestHighlight < TestHelper

  context "single line <code>" do
    setup do 
      @code = StringIO.new(%{
        <code part="aaa">
      })
    end
    
    should "have options set" do
      cbp = PmlCode::CodeBlockProcessor.new(@code.gets, @code)
      assert_equal 'aaa', cbp.code_options['part']
    end
  end
  
  context "multi line <code>" do
    setup do 
      @code = StringIO.new(%{
        <code 
              part="aaa"
        >
      })
    end
    
    should "have options set" do
      cbp = PmlCode::CodeBlockProcessor.new(@code.gets, @code)
      assert_equal 'aaa', cbp.code_options['part']
    end
  end  
  
  context "simple inline code" do
    setup do 
      @code = StringIO.new(%{
        <code>
          line 1
            line 1a
          line 2
        </code>
      })
      @cbp = PmlCode::CodeBlockProcessor.new(@code.gets, @code)
    end

    should "be read completely, with the correct indentation" do
      assert_equal(["line 1", "  line 1a", "line 2"], @cbp.load_code)
    end
  end
  
  context "inline code with cdata" do
    setup do 
      @code = StringIO.new(%{
        <code>
          <![CDATA[
          line 1
            line 1a
          line 2
          ]]>
        </code>
      })
      @cbp = PmlCode::CodeBlockProcessor.new(@code.gets, @code)
    end

    should "strip cdata" do
      assert_equal(["line 1", "  line 1a", "line 2"], @cbp.load_code)
    end
  end

  context "inline code with cdata and verbatim option" do
    setup do 
      @code = StringIO.new(%{
        <code verbatim="yes">
          <![CDATA[
          line 1
            line 1a
          line 2
          ]]>
        </code>
      })
      @cbp = PmlCode::CodeBlockProcessor.new(@code.gets, @code)
    end

    should "not strip cdata" do
      assert_equal(["<![CDATA[", "line 1", "  line 1a", "line 2", "]]>"], @cbp.load_code)
    end
  end

  context "ruby inline code" do
    setup do 
      @code = StringIO.new(%{
        <ruby>
          line 1
            line 1a
          line 2
        </ruby>
      })
      @cbp = PmlCode::CodeBlockProcessor.new(@code.gets, @code)
    end

    should "be read completely, with the correct indentation" do
      assert_equal(["line 1", "  line 1a", "line 2"], @cbp.load_code)
    end
    
    should "have a language of ruby" do
      assert_equal "ruby", @cbp.code_options['language'] 
    end
  end

  context "inline code with a part" do
    setup do 
      @code = StringIO.new(%{
        <code part="xxx">
          line 0
          #START:xxx
          line 1
            #START: yyy
            line 1a
          #END:xxx
          line 2
          #END: yyy
        </code>
      })
      @cbp = PmlCode::CodeBlockProcessor.new(@code.gets, @code)
    end

    should "be read completely, with the correct indentation, and ignore other start/end lines" do
      assert_equal(["line 1", "  line 1a"], @cbp.load_code)
    end
  end

  context "inline code with a start/end" do
    setup do 
      @code = StringIO.new(%{
        <code start="line 1" end="1a">
          line 0
          line 1
            line 1a
          line 2
        </code>
      })
      @cbp = PmlCode::CodeBlockProcessor.new(@code.gets, @code)
    end

    should "be read completely, with the correct indentation" do
      assert_equal(["line 1", "  line 1a"], @cbp.load_code)
    end
  end

  context "inline code with a start/end-exclude" do
    setup do 
      @code = StringIO.new(%{
        <code start="line 1" end-exclude="1a">
          line 0
          line 1
            line 1a
          line 2
        </code>
      })
      @cbp = PmlCode::CodeBlockProcessor.new(@code.gets, @code)
    end

    should "not include the excluded line" do
      assert_equal(["line 1"], @cbp.load_code)
    end
  end

  context "inline code with a start" do
    setup do 
      @code = StringIO.new(%{
        <code start="line 1">
          line 0
          line 1
            line 1a
          line 2
        </code>
      })
    end
    should "raise an exception without an end" do
      assert_raises(RuntimeError) { PmlCode::CodeBlockProcessor.new(@code.gets, @code).load_code }
    end
  end

  context "simple inline ruby code" do
    setup do 
      @code = StringIO.new(%{
        before
        <code language="ruby">
          def fred
            "cat" # comment
          end
        </code>
        after
      })
      @cbp = PmlCode::CodeBlockProcessor.new(@code.gets, @code)
    end

    should "be formatted" do
      assert_lines(code(%{
        <processedcode language="ruby">
        <codeline><cokw>def</cokw> fred</codeline>
        <codeline>  <costring>"cat"</costring> <cocomment># comment</cocomment></codeline>
        <codeline><cokw>end</cokw></codeline>
        </processedcode>}), @cbp.process)
    end
  end
end