require 'pp'
require 'nokogiri'
include Nokogiri::XML

edition_names = {
  "2" => "2nd", "3" => "2rd", "4" => "4th"
}

@doc = Document.new
result = Node.new("bibliography", @doc)

xml = Nokogiri::XML(File.read("products.xml"))

xml.xpath(%{//product}).sort_by {|e| (e > "code").text }.each do |entry|
  values = Hash[
    %i{ title  author code pubdate isbn13 product_url edition print_status}.map do |key|
      [ key, (entry > key.to_s).text ]
    end
  ]

  next if values[:print_status] == "Cancelled"

  if values[:print_status] == "Out of Print"
    values[:title] << " (out of print)"
  end

  authors = values[:author].split(/\s+and\s+/)

  values[:author] = authors.map do |author|
    parts = author.split(/\s+/)
    last = parts.pop
    [ parts.join(" "), last ]
  end

  cite = Node.new("book", @doc)
  cite["tag"] = "pp:#{values[:code]}"
  as = Node.new("authors", @doc)
  for name in values[:author]
    a = Node.new("author", @doc)
    g = Node.new("given", @doc)
    g.content = name.first
    f = Node.new("family", @doc)
    f.content = name.last
    a.add_child(g)
    a.add_child(f)
    as.add_child(a)
  end
  cite << as

  title = Node.new("title", @doc)
  title.content = values[:title]
  cite << title

  isbn = Node.new("isbn", @doc)
  isbn.content = values[:isbn13]
  cite << isbn

  year = Node.new("year", @doc)
  year.content = values[:pubdate].split(/-/).first
  cite << year

  ed = values[:edition]
  if ed && ed != "1"
    edition = Node.new("edition", @doc)
    edition.content = edition_names[ed] || ed
    cite << edition
  end

  pub = Node.new("publisher", @doc)
  pub["ref"] = "pub.pp"
  cite << pub

  result.add_child(cite)
end

  puts result.to_xml(encoding: "UTF-8")


  # <book tag="subramaniam:pad">
  #   <authors>
  #     <author>
  #       <given>Venkat</given>
  #       <family>Subramaniam</family>
  #     </author>
  #     <author>
  #       <given>Andy</given>
  #       <family>Hunt</family>
  #     </author>
  #   </authors>
  #   <title>Practices of an Agile Developer: Working in the Real World</title>
  #   <year>2006</year>
  #   <publisher ref="pub.pp"/>
  #   <isbn>978-0-9745140-8-6</isbn>
  #   <url>http://www.pragprog.com/titles/pad/practices-of-an-agile-developer</url>
  # </book>
  # 
  # p authors
  # exit
#end
