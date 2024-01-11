require_relative 'indexer_test'
require_relative '../lib/entry_list'

class TestEntryList < IndexerTest
  
  context "An empty entry_list" do
    setup do 
      @entry_list = EntryList.new
    end
    
    should "not have any errors or warnings" do
      assert_equal [], @entry_list.errors
      assert_equal [], @entry_list.warnings
    end
  end
  
  context "Two entries with the same collation" do
    setup do
      @entry_list = EntryList.new
      @entry_list.record(original_entry('<i sortas="a">some text</i>'))
    end

    context "and the same display text" do
      setup do
        @entry_list.record(original_entry('<i sortas="a">some text</i>'))
      end
      should "not generate a warning" do
        assert_equal 0, @entry_list.warnings.size
      end
    end
    
    context "and different display text" do
      setup do
        @entry_list.record(original_entry('<i sortas="a">other text</i>'))
      end
      should "generate a warning" do
        assert_equal 1, @entry_list.warnings.size
      end
    end
  end
  
  context "a top level and a two-level entry with the same head" do
    setup do 
      @entry_list = entry_list("<i>one</i>", "<i>one<ii>two</ii></i>")  
    end                                                          
  
    should "have two entries, with the single one first" do
      list = @entry_list.each

      _, first = list.next
      assert_equal 0, first.highest_level
      assert_equal "one ", first.collation_for_level(0)
      
      _, second = list.next
      assert_equal 1, second.highest_level
      assert_equal "one ", second.collation_for_level(0)
      assert_equal "two ", second.collation_for_level(1)

      assert_raises(StopIteration) { empty = list.next; STDERR.puts empty.inspect }
    end
  end
  
end