require 'test/unit'

require 'publish_code'

class TestPublishCode < Test::Unit::TestCase
  
  def test_simple_massage
    str = "123\n456\n"
    assert_equal str, massage(str)
  end

  def test_massage_with_start_end
    str = %{line 1\n# START:xx\nline 2\n# END:xx\nline 3\n}
    assert_equal(%{line 1\nline 2\nline 3\n}, massage(str))
  end
  
  def test_massage_with_multiple_start_end
    str = %{line 1\n# START:xx\nline 2\n# END:xx\n# START:yy\nline 2a\n#END:yy\nline 3\n}
    assert_equal(%{line 1\nline 2\nline 2a\nline 3\n}, massage(str))
  end

  def test_massage_with_labels
    str = %{  mp.seekTo(0); //<label id="code.seekTo" />\n  mp.start();\n}
    assert_equal %{  mp.seekTo(0); \n  mp.start();\n}, massage(str)
  end
  
end
