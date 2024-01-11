require_relative 'indexer_test'
require_relative '../lib/head_list'

class TestHeadList < IndexerTest   
  context "A head list with a single entry" do
    setup do
      @hl = HeadList.from_entry_list(entry_list("<i>one</i>"))
    end 
    
    should "have one entry" do
      assert_equal 1, @hl.list.size
    end
  end 
  
  context "A head list with two disparate entries" do
    setup do
      @hl = HeadList.from_entry_list(entry_list("<i>one</i>", "<i>two</i>"))
    end 
    
    should "have two entries" do
      assert_equal 2, @hl.list.size
    end
  end


  context "A head list with two entries, where one is a child of another," do
    setup do
      @hl = HeadList.from_entry_list(entry_list("<i>one</i>", "<i>one<ii>two</ii></i>"))
    end 
    
    should "have two entries" do 
      assert_equal 1, @hl.list.size
    end
  end
end