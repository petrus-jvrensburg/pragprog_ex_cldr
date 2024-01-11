require 'test/unit'
require 'shoulda'

class TestHelper < Test::Unit::TestCase
  def code(string)
    lines = string.gsub(/\t/, '..').split("\n")
    lines.shift if lines[0] == ""
    lines[0] =~ /^(\s+)/
    leading = $1
    lines.map {|l| l.sub(/^#{leading}/, '')}.join("\n")
  end

  def assert_lines(expected, actual, message=nil)
    elines = expected.split(/\n/)
    alines = actual.split(/\n/)
    assert_equal elines.size, alines.size, "#{message}: number of lines in expected differs to actual (got #{actual.inspect})"
    until elines.empty? 
      e = elines.shift
      a = alines.shift
      assert_equal e, a, message
    end
  end
end