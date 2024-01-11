require_relative 'indexer_test'
require_relative '../lib/entry'

class TestEntry < IndexerTest

  context "A new entry with a single level <i>" do
    setup do
      @entry = Entry.new(original_entry("<i>one</i>"))
    end
    should "have a head term equal to the entry" do
      assert_equal "one ", @entry.head_term
    end
    should "have a first letter set from the entry" do
      assert_equal "O", @entry.first_letter
    end   
    should "have a page number" do
      assert @entry.has_page_number?
    end
  end
   
  context "A new entry with a see=" do
    setup do
      @entry = Entry.new(original_entry('<i see="123">one</i>'))
    end
    should "not have a page number" do
      refute @entry.has_page_number?
    end
  end
  
  context "An entry for <i>123</i>" do
    setup do
      @entry = Entry.new(original_entry("<i>123</i>"))
    end
                                               
    should "have a first letter of Digits" do
      assert_equal "Digits", @entry.first_letter
    end                                 
  end

  context "An entry for <i>$</i>" do
    setup do
      @entry = Entry.new(original_entry("<i>$</i>"))
    end
                                               
    should "have a first letter of Symbols" do
      assert_equal "Symbols", @entry.first_letter
    end                                 
  end
end