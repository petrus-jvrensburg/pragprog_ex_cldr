class Book < Annotator

  def create_bib_line(entry)
    line = Nokogiri::XML::Node.new("bib-line", @doc)
    line << text(author_names(entry) + ". ")
    line << bookname(title(entry))
    
    fields = publisher(entry).concat(edition(entry)).concat(date(entry))
    line << text(". " + fields.join(", "))
    line << "."
    entry.add_child(line)
  end

end

