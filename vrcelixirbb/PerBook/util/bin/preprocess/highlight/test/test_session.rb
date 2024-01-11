require_relative 'test_helper'

require_relative '../lib/pml_code/highlight'

module PmlCode
  class Highlight
    attr_reader :lines, :tokens
  end
end

# Test the session scanner
class TestSession < TestHelper

  context "one simple line" do
    setup do
      @encoder = PmlCode::Highlight.new("a", :session)
    end
    should "look like output" do
      assert_equal [ ["a",:output] ], @encoder.tokens
    end
  end


  context "one simple line with a $ prompt" do
    setup do
      @encoder = PmlCode::Highlight.new("prompt$ a", :session)
    end
    should "look like a prompt followed by user input" do
      assert_equal [ ["prompt$ ", :prompt], ["a",:user_input] ], @encoder.tokens
    end
  end

  context "one simple line with a dos prompt" do
    setup do
      @encoder = PmlCode::Highlight.new("c:\\tmp> a", :session)
    end
    should "look like a prompt followed by user input" do
      assert_equal [ ["c:\\tmp>", :prompt], [" a",:user_input] ], @encoder.tokens
    end
  end

  context "prompt and input, followed by output" do
    setup do
      @encoder = PmlCode::Highlight.new("prompt$ a\nb\nc", :session)
    end
    should "look like a prompt followed by user input followed by output" do
      assert_equal [ ["prompt$ ", :prompt], ["a\n",:user_input], ["b\n",:output], ["c",:output] ], @encoder.tokens
    end
  end

  context "prompt and input, continuation, followed by output" do
    setup do
      @encoder = PmlCode::Highlight.new("prompt$ a\\\\\nb\nc", :session)
    end
    should "look like a prompt followed by user input followed by output" do
      assert_equal [ ["prompt$ ", :prompt], ["a\\\\\n",:user_input], ["b\n",:user_input], ["c",:output] ], @encoder.tokens
    end
  end


end