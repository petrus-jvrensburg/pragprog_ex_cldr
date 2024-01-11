require_relative 'indexer_test'
require_relative '../lib/original_entry'

class TestOriginalEntry < IndexerTest  
  
  EXPECTED_COLLATIONS = {

    # straight entries
    '<i>one</i>'                             => [ 'one ' ],
    '<i>one<ii>two</ii></i>'                 => [ 'one ', 'two ' ],
    '<i>one<ii>two<iii>three</iii></ii></i>' => [ 'one ', 'two ', 'three ' ],

    # Upper case should not have trailing spaces
    '<i>ONE</i>'                             => [ 'one' ],
    '<i>ONE<ii>two</ii></i>'                 => [ 'one', 'two ' ],
    '<i>One<ii>Two<iii>Three</iii></ii></i>' => [ 'one', 'two', 'three' ],
    
    # Ignore extra spaces
    '<i>  one
           </i>'                             => [ 'one ' ],
    '<i>one<ii>  two  </ii></i>'             => [ 'one ', 'two ' ],
    '<i> one      two</i>'                   => [ 'one two ' ],
    
    # Ignore punctuation if immediately followed by a word character
    
    '<i>@name</i>'                           => [ 'name ' ],
    '<i>variable<ii>$DEBUG</ii></i>'         => [ 'variable ', 'debug' ],
    
    # But not if it is followed by a space
    '<i>@ (at sign)</i>'                     => [ '@ (at sign) ' ],  

    # Markup is ignored when creating collation
    
    '<i><ic>puts</ic> method</i>'     => [ 'puts method ' ],
    '<i>the <ic>puts</ic> method</i>' => [ 'puts method ' ], 
    '<i><ic>$DEBUG</ic> variable</i>' => [ 'debug variable' ],   

    # and in all cases sortas= overrides    
    '<i sortas="a">one</i>'                                        => [ 'a ' ],
    '<i sortas="a">one<ii>two</ii></i>'                            => [ 'a ',  'two ' ],
    '<i>one<ii sortas="b">two</ii></i>'                            => [ 'one ',  'b ' ],
    '<i sortas="a">one<ii>two<iii sortas="C">three</iii></ii></i>' => [ 'a ', 'two ', 'c' ],
    '<i sortas="a">one<ii>  two  </ii></i>'                        => [ 'a ', 'two ' ],
    '<i sortas="ab"> one      two</i>'                             => [ 'ab ' ],
    '<i sortas="@name">@name</i>'                                  => [ '@name ' ],
    '<i>variable<ii sortas="dollar">$DEBUG</ii></i>'               => [ 'variable ', 'dollar ' ],
    
  }
  
  def test_collations
    EXPECTED_COLLATIONS.each do |entry, result|
      oe = OriginalEntry.new(i_from_string(entry))
      assert_equal result, oe.collations
    end
  end
end